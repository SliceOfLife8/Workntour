//
//  TravelerProfileVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 15/6/22.
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
        }
    }


    // MARK: - Life Cycle

    override func bindViews() {
        super.bindViews()

        viewModel?.$newImage
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] data in
                let headerView = self?.collectionView.supplementaryView(
                    forElementKind: UICollectionView.elementKindSectionHeader,
                    at: .init(row: 0, section: 0)
                ) as? ProfileHeaderView
                headerView?.updateImage(data)
                print("talk with VM in order to update profile!")
            })
            .store(in: &storage)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension TravelerProfileVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TravelerProfileSection.allCases.count - 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if TravelerProfileSection(rawValue: indexPath.row) == .languages {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProfileSimpleCell.identifier,
                for: indexPath
            ) as? ProfileSimpleCell,
                  let data = viewModel?.getLanguageCellDataModel()
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

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if TravelerProfileSection(rawValue: indexPath.row) == .languages {
            guard let dataModel = viewModel?.getLanguageCellDataModel() else { return .zero }
            return dataModel.sizeForItem(in: collectionView)
        }
        else {
            guard let dataModel = viewModel?.getSimpleCellDataModel(indexPath.row) else { return .zero }
            return dataModel.sizeForItem(in: collectionView)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let dataModel = viewModel?.getHeaderDataModel() else { return .zero }
        return dataModel.sizeForItem(in: collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
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
        print("update profile!")
    }

    func driverLicenseHasChanged(_ hasLicense: Bool) {
        print("update profile!")
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
            self.coordinator?.navigate(to: .travelerAddSummary(nil))
        case 2:
            self.coordinator?.navigate(to: .travelerSelectType(data.type))
        case 3:
            self.coordinator?.navigate(to: .selectInterests(preselectedInterests: []))
        default:
            self.coordinator?.navigate(to: .selectSkills(preselectedSkills: []))
        }
    }
}
