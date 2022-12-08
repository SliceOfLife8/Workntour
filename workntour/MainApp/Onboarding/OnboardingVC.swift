//
//  OnboardingVC.swift
//  workntour
//
//  Created by Chris Petimezas on 7/12/22.
//

import UIKit
import CommonUI

class OnboardingVC: BaseVC<OnboardingViewModel, OnboardingCoordinator> {

    // MARK: - Outlets

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(
                UINib(nibName: OnboardingCell.identifier,
                      bundle: Bundle(for: OnboardingCell.self)),
                forCellWithReuseIdentifier: OnboardingCell.identifier
            )
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }

    @IBOutlet weak var nextButton: PrimaryButton!

    @IBOutlet weak var pageControl: UIPageControl!

    override func setupUI() {
        super.setupUI()
        pageControl.numberOfPages = viewModel?.totalPages ?? 0
    }

    @IBAction func nextButtonTapped(_ sender: Any) {
        guard let viewModel,
              let coordinator = self.coordinator
        else {
            return
        }
        // Last page
        if pageControl.currentPage == viewModel.totalPages - 1 {
            coordinator.delegate?.onboardingCoordinatorDidFinish(
                coordinator,
                userIsGranted: true
            )
        }
        else {
            pageControl.currentPage += 1
            collectionView.scrollToItem(
                at: IndexPath(item: pageControl.currentPage, section: 0),
                at: .centeredHorizontally,
                animated: true
            )
            let lastPage = pageControl.currentPage == collectionView.numberOfItems(inSection: 0) - 1
            nextButton.setTitle(
                lastPage ? "get_started".localized() : "next".localized(),
                for: .normal
            )
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension OnboardingVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.totalPages ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OnboardingCell.identifier,
            for: indexPath
        ) as? OnboardingCell,
              let data = viewModel?.getDataModel(indexPath.row)
        else {
            return UICollectionViewCell()
        }

        cell.configureLayout(for: data)
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return collectionView.frame.size
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = page
        /// Check if user is on lastPage and show proper title for button
        let lastPage = page == collectionView.numberOfItems(inSection: 0) - 1
        nextButton.setTitle(
            lastPage ? "get_started".localized() : "next".localized(),
            for: .normal
        )
    }
}
