//
//  OpportunitiesVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 15/6/22.
//

import UIKit
import SharedKit
import CommonUI
import CombineDataSources

/*
 1. Create a list of opportunities. Basically it's a collectionView. https://github.com/appssemble/appstore-card-transition
 2. Create an opportunity. We need to integrate the AirBnb's calendar https://github.com/airbnb/HorizonCalendar.
 3. Details View.
 4. Delete option on detailsView.
 */

class OpportunitiesVC: BaseVC<OpportunitiesViewModel, OpportunitiesCoordinator> {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.viewModel?.fetchModels()
        }
    }

    override func setupUI() {
        super.setupUI()

        collectionView.register(UINib(nibName: MyOpportunityCell.identifier, bundle: Bundle(for: MyOpportunityCell.self)), forCellWithReuseIdentifier: MyOpportunityCell.identifier)
        collectionView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationBar(mainTitle: "Opportunities", largeTitle: true)
        let plusIcon = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(createNewOpportunityAction))
        navigationItem.rightBarButtonItems = [plusIcon]
    }

    override func bindViews() {
        super.bindViews()

        viewModel?.$data
            .bind(subscriber: collectionView.itemsSubscriber(cellIdentifier:
                                                                MyOpportunityCell.identifier,
                                                             cellType: MyOpportunityCell.self,
                                                                cellConfig: { (cell, _, model) in
                cell.configure(
                    model.images.first,
                    jobTitle: model.jobTitle,
                    location: model.location.title,
                    category: model.category.rawValue,
                    dates: model.dates.map { ($0.start, $0.end) })
            }))
            .store(in: &storage)
    }

    @objc func createNewOpportunityAction() {
        self.coordinator?.navigate(to: .createOpportunity)
    }

}

extension OpportunitiesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 48, height: 300)
    }
}
