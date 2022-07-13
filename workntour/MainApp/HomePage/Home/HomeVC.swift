//
//  HomeVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 17/6/22.
//

import UIKit
import SharedKit
import CommonUI
import SkeletonView

/*
 1. Create list of opportunities
 3. Add filters
 4. Add map
 */

class HomeVC: BaseVC<HomeViewModel, HomeCoordinator> {

    private lazy var resultsVC: OpportunitiesResultsVC = {
        let results = OpportunitiesResultsVC()
        results.delegate = self
        return results
    }()

    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: resultsVC)
        return search
    }()

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }

    override func setupUI() {
        super.setupUI()

        mapButton.layer.cornerRadius = 16
        mapButton.isHidden = false
        collectionView.register(UINib(nibName: MyOpportunityCell.identifier, bundle: Bundle(for: MyOpportunityCell.self)), forCellWithReuseIdentifier: MyOpportunityCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = UIColor.appColor(.lavender)
        navigationItem.title = "Home Page"
        let filterIcon = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(filtersTapped))
        navigationItem.rightBarButtonItems = [filterIcon]
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.tintColor = UIColor.appColor(.lavender)
    }

    override func bindViews() {
        super.bindViews()

        viewModel?.$data
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .store(in: &storage)
    }

    @objc func filtersTapped() {
        print("open filters modal!")
    }

    @IBAction func mapButtonTapped(_ sender: Any) {
        self.coordinator?.navigate(to: .showMap)
    }
}

// MARK: - Delegates about UISearchBar
extension HomeVC: UISearchResultsUpdating, UISearchControllerDelegate, OpportunitiesResultsDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        GooglePlacesManager.shared.findPlaces(query: query) { result in
            switch result {
            case .success(let places):
                DispatchQueue.main.async {
                    self.resultsVC.update(with: places)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        // Check that current searchBar text is empty & home page has already a selected place
        print("call api without coordinates when it's necessary! \(searchController.searchBar.text)")
    }

    func didSelectPlace(_ name: String, latitude: Double, longitude: Double) {
        print("Place: \(name), \(latitude) - \(longitude)")
        searchController.searchBar.text = name
        searchController.dismiss(animated: true)
    }
}

// MARK: - CollectionView Delegates
extension HomeVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, SkeletonCollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyOpportunityCell.identifier, for: indexPath) as! MyOpportunityCell

        if let model = viewModel?.data?[safe: indexPath.row] {
            cell.hideSkeleton()
            cell.configure(
                URL(string: model.imageUrls.first ?? ""),
                jobTitle: model.title,
                location: model.location.placemark?.simpleFormat(),
                category: model.category.value,
                dates: model.dates.map { ($0.start, $0.end) })
        } else {
            cell.showAnimatedGradientSkeleton()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.data?.count ?? 3
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return MyOpportunityCell.identifier
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 48, height: 300)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let opportunityId = viewModel?.data?[safe: indexPath.row]?.opportunityId else {
            return
        }
        print("select opportunity with id: \(opportunityId)")
    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return false
    }
}
