//
//  HostProfileVC.swift
//  workntour
//
//  Created by Chris Petimezas on 19/6/22.
//

import UIKit
import SharedKit
import CommonUI

class HostProfileVC: BaseVC<HostProfileViewModel, ProfileCoordinator> {

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
                //self?.viewModel?.updateProfile(withMedia: media)
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
//                    self?.viewModel?.traveler = UserDataManager.shared.retrieve(TravelerProfileDto.self)
//                    self?.viewModel?.profileUpdated = true
                }
            })
            .store(in: &storage)
    }


    // MARK: - Actions

    @objc
    private func pullToRefresh() {
        collectionView.refreshControl?.endRefreshing()
        // viewModel?.retrieveProfile()
    }

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension HostProfileVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HostProfileSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        default:
            fatalError("Unexpected element kind")
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let dataModel = viewModel?.getSimpleCellDataModel(indexPath.row) else { return .zero }
        return dataModel.sizeForItem(in: collectionView)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        guard let dataModel = viewModel?.getHeaderDataModel() else { return .zero }
        return dataModel.sizeForItem(in: collectionView)
    }
}

// MARK: - ProfileHeaderViewDelegate
extension HostProfileVC: ProfileHeaderViewDelegate {

    func showImagePicker() {
        self.coordinator?.navigate(to: .openGalleryPicker)
    }
}

// MARK: - ProfileSimpleCellDelegate
extension HostProfileVC: ProfileSimpleCellDelegate {

    func contentViewDidSelect(_ cell: ProfileSimpleCell) {
        guard let index = collectionView.indexPath(for: cell)?.row,
              let data = viewModel?.companyHost
        else {
            return
        }

        if index == 0 {
            self.coordinator?.navigate(to: .travelerEditPersonalInfo)
        }
        else {
            print("navigate to open description")
        }
    }
}
