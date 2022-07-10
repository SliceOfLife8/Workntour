//
//  HomeVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 17/6/22.
//

import UIKit
import SharedKit

/*
 1. Create list of opportunities
 2. Add search bar & call google api service for places
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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }

    override func setupUI() {
        super.setupUI()

        view.backgroundColor = UIColor.appColor(.primary)
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Home Page"
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.tintColor = UIColor.appColor(.lavender)
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
