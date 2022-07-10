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

// TODO: Transition animation to details view -> https://github.com/appssemble/appstore-card-transition

class OpportunitiesVC: BaseVC<OpportunitiesViewModel, OpportunitiesCoordinator> {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel?.fetchModels()
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
                    URL(string: model.imageUrls.first ?? ""),
                    jobTitle: model.title,
                    location: model.location.placemark?.simpleFormat(),
                    category: model.category.value,
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let opportunityId = viewModel?.data[safe: indexPath.row]?.opportunityId else {
            assertionFailure("Opportunity must have an ID!")
            return
        }
        self.coordinator?.navigate(to: .showDetailsView(id: opportunityId))
    }
}
