//
//  TravelerProfileVC.swift
//  workntour
//
//  Created by Chris Petimezas on 15/6/22.
//

import UIKit
import SharedKit
import CommonUI

class TravelerProfileVC: BaseVC<TravelerProfileViewModel, ProfileCoordinator> {

    // MARK: - Outlets

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(
                UINib(nibName: ProfileSimpleCell.identifier,
                      bundle: Bundle(for: ProfileSimpleCell.self)),
                forCellWithReuseIdentifier: ProfileSimpleCell.identifier
            )
            collectionView.register(
                UINib(nibName: ProfileLanguageCell.identifier,
                      bundle: Bundle(for: ProfileLanguageCell.self)),
                forCellWithReuseIdentifier: ProfileLanguageCell.identifier
            )
            collectionView.register(
                UINib(nibName: ProfileExperienceCell.identifier,
                      bundle: Bundle(for: ProfileExperienceCell.self)),
                forCellWithReuseIdentifier: ProfileExperienceCell.identifier
            )
            collectionView.register(
                UINib(nibName: ProfileHeaderView.identifier,
                      bundle: Bundle(for: ProfileHeaderView.self)),
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: ProfileHeaderView.identifier
            )
            collectionView.register(
                UINib(nibName: ProfileFooterView.identifier,
                      bundle: Bundle(for: ProfileFooterView.self)),
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: ProfileFooterView.identifier
            )
            collectionView.delegate = self
            collectionView.dataSource = self
            let refreshControl = UIRefreshControl()
            refreshControl.tintColor = UIColor.appColor(.purple)
            refreshControl.addTarget(
                self,
                action: #selector(pullToRefresh),
                for: .valueChanged
            )
            collectionView.refreshControl = refreshControl
        }
    }


    // MARK: - Life Cycle

    override func bindViews() {
        super.bindViews()

        viewModel?.$newImage
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] media in
                let headerView = self?.collectionView.supplementaryView(
                    forElementKind: UICollectionView.elementKindSectionHeader,
                    at: .init(row: 0, section: 0)
                ) as? ProfileHeaderView
                headerView?.updateImage(media.data)
                self?.viewModel?.updateProfile(withMedia: media)
            })
            .store(in: &storage)

        viewModel?.$profileUpdated
            .dropFirst()
            .sink(receiveValue: { [weak self] status in
                if status {
                    self?.viewModel?.shouldShowAnimation = true
                    self?.collectionView.reloadData()
                }
                else {
                    self?.coordinator?.navigate(
                        to: .state(
                            .showAlert(
                                title: "",
                                subtitle: "Something went wrong!\nPlease try again"
                            )
                        ))
                }
            })
            .store(in: &storage)

        viewModel?.$getRefreshedProfile
            .sink(receiveValue: { [weak self] status in
                if status {
                    self?.viewModel?.traveler = UserDataManager.shared.retrieve(TravelerProfileDto.self)
                    self?.viewModel?.profileUpdated = true
                }
            })
            .store(in: &storage)
    }

    // MARK: - Actions

    @objc
    private func pullToRefresh() {
        collectionView.refreshControl?.endRefreshing()
        viewModel?.retrieveProfile()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension TravelerProfileVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TravelerProfileSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if TravelerProfileSection(rawValue: indexPath.row) == .languages {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProfileLanguageCell.identifier,
                for: indexPath
            ) as? ProfileLanguageCell,
                  let data = viewModel?.getLanguageCellDataModel()
            else {
                assertionFailure("Check viewModel attributes!")
                return UICollectionViewCell()
            }

            cell.configureLayout(for: data)
            cell.delegate = self
            return cell
        }
        else if TravelerProfileSection(rawValue: indexPath.row) == .experience {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProfileExperienceCell.identifier,
                for: indexPath
            ) as? ProfileExperienceCell,
                  let data = viewModel?.getExperienceCellDataModel()
            else {
                assertionFailure("Check viewModel attributes!")
                return UICollectionViewCell()
            }

            cell.configureLayout(for: data)
            cell.delegate = self
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProfileSimpleCell.identifier,
                for: indexPath
            ) as? ProfileSimpleCell,
                  let data = viewModel?.getSimpleCellDataModel(indexPath.row)
            else {
                assertionFailure("Check viewModel attributes!")
                return UICollectionViewCell()
            }

            cell.configureLayout(for: data)
            cell.delegate = self
            return cell
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProfileHeaderView.identifier,
                for: indexPath
            ) as? ProfileHeaderView,
                  let viewModel,
                  let dataModel = viewModel.getHeaderDataModel()
            else {
                return UICollectionReusableView()
            }

            headerView.configureLayout(for: dataModel)
            headerView.delegate = self
            if viewModel.shouldShowAnimation {
                headerView.startAnimation()
                viewModel.shouldShowAnimation.toggle()
            }

            return headerView
        case UICollectionView.elementKindSectionFooter:
            guard let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProfileFooterView.identifier,
                for: indexPath
            ) as? ProfileFooterView,
                  let dataModel = viewModel?.getFooterDataModel()
            else {
                return UICollectionReusableView()
            }

            footerView.configureLayout(for: dataModel)
            footerView.delegate = self

            return footerView
        default:
            fatalError("Unexpected element kind")
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if TravelerProfileSection(rawValue: indexPath.row) == .languages {
            guard let dataModel = viewModel?.getLanguageCellDataModel() else { return .zero }
            return dataModel.sizeForItem(in: collectionView)
        }
        else if TravelerProfileSection(rawValue: indexPath.row) == .experience {
            guard let dataModel = viewModel?.getExperienceCellDataModel() else { return .zero }
            return dataModel.sizeForItem(in: collectionView)
        }
        else {
            guard let dataModel = viewModel?.getSimpleCellDataModel(indexPath.row) else { return .zero }
            return dataModel.sizeForItem(in: collectionView)
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        guard let dataModel = viewModel?.getHeaderDataModel() else { return .zero }
        return dataModel.sizeForItem(in: collectionView)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        guard let dataModel = viewModel?.getFooterDataModel() else { return .zero }
        return dataModel.sizeForItem(in: collectionView)
    }

}

// MARK: - ProfileHeaderViewDelegate && ProfileFooterViewDelegate
extension TravelerProfileVC: ProfileHeaderViewDelegate, ProfileFooterViewDelegate {

    func showImagePicker() {
        self.coordinator?.navigate(to: .openGalleryPicker)
    }

    func dietaryHasChanged(at index: Int) {
        viewModel?.traveler?.specialDietary = SpecialDietary(index)
        viewModel?.updateProfile()
    }

    func driverLicenseHasChanged(_ hasLicense: Bool) {
        viewModel?.traveler?.driverLicense = hasLicense
        viewModel?.updateProfile()
    }
}

// MARK: - ProfileSimpleCellDelegate
extension TravelerProfileVC: ProfileSimpleCellDelegate {

    func contentViewDidSelect(_ cell: ProfileSimpleCell) {
        guard let index = collectionView.indexPath(for: cell)?.row,
              let data = viewModel?.traveler
        else {
            return
        }
        // You should check TravelerProfileSections rawValues to fetch this logic.
        switch index {
        case 0:
            self.coordinator?.navigate(to: .travelerEditPersonalInfo)
        case 1:
            self.coordinator?.navigate(to: .travelerAddSummary(data.description))
        case 2:
            self.coordinator?.navigate(to: .travelerSelectType(data.type))
        case 3:
            self.coordinator?.navigate(
                to: .selectInterests(
                    preselectedInterests: data.interests ?? []
                )
            )
        default:
            self.coordinator?.navigate(
                to: .selectSkills(
                    preselectedSkills: data.skills ?? []
                )
            )
        }
    }
}

// MARK: - ProfileLanguageCellDelegate
extension TravelerProfileVC: ProfileLanguageCellDelegate {

    func addNewLanguage() {
        let existingLanguages = viewModel?.traveler?.languages?.compactMap { $0.language } ?? []
        self.coordinator?.navigate(to: .addLanguage(existingLanguages: existingLanguages))
    }

    func editLanguage(at index: Int) {
        guard let language = viewModel?.traveler?.languages?[safe: index] else { return }
        self.coordinator?.navigate(to: .editLanguage(language))
    }

    func deleteLanguage(at index: Int) {
        viewModel?.traveler?.languages?.remove(at: index)
        viewModel?.updateProfile()
    }
}

// MARK: - ProfileExperienceCellDelegate
extension TravelerProfileVC: ProfileExperienceCellDelegate {

    func addNewExperience() {
        self.coordinator?.navigate(to: .openExperience(nil))
    }

    func editExperience(withUUID uuid: String) {
        print("edit: \(uuid)")
    }

    func deleteExperience(withUUID uuid: String) {
        print("delete: \(uuid)")
    }
}
