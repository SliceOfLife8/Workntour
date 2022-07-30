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

class HomeVC: BaseVC<HomeViewModel, HomeCoordinator> {
    // MARK: - Vars
    private lazy var resultsVC: OpportunitiesResultsVC = {
        let results = OpportunitiesResultsVC()
        results.delegate = self
        return results
    }()

    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: resultsVC)
        return search
    }()

    private lazy var searchBarHeight: CGFloat = {
        return -searchController.searchBar.frame.height
    }()

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        viewModel?.getOpportunities()
        // SearchBar on navigationController does not appear at some devices. A workaround is the following one.
        collectionView.setContentOffset(CGPoint(x: 0, y: searchBarHeight), animated: false)
    }

    override func setupUI() {
        super.setupUI()

        mapButton.layer.cornerRadius = 16
        collectionView.register(UINib(nibName: MyOpportunityCell.identifier, bundle: Bundle(for: MyOpportunityCell.self)), forCellWithReuseIdentifier: MyOpportunityCell.identifier)
        collectionView.register(
            UINib(nibName: OpportunitiesFooterView.identifier, bundle: Bundle(for: OpportunitiesFooterView.self)),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: OpportunitiesFooterView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.appColor(.purple)
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
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
            .sink(receiveValue: { [weak self] data in
                if self?.viewModel?.filters.areaIsFilled == true, data.count > 0 {
                    self?.viewModel?.mapIsHidden = false
                }

                self?.viewModel?.collectionViewIsUpdating = false
                self?.collectionView.reloadData()
            })
            .store(in: &storage)

        viewModel?.$data
            .map { $0.count > 0 }
            .receive(on: RunLoop.main)
            .assign(to: \.isScrollEnabled, on: collectionView)
            .store(in: &storage)

        viewModel?.$mapIsHidden
            .receive(on: RunLoop.main)
            .assign(to: \.isHidden, on: mapButton)
            .store(in: &storage)

        viewModel?.$errorMessage
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] message in
                self?.coordinator?.navigate(to: .state(.showAlert(title: message, subtitle: nil)))
            })
            .store(in: &storage)
    }

    // MARK: - Actions
    @objc func filtersTapped() {
        self.coordinator?.navigate(to: .showFilters)
    }

    @objc func pullToRefresh() {
        collectionView.refreshControl?.endRefreshing()
        viewModel?.resetPagination()
    }

    @IBAction func mapButtonTapped(_ sender: Any) {
        guard let longitude = viewModel?.filters.longitude,
              let latitude = viewModel?.filters.latitude else {
            assertionFailure()
            return
        }

        self.coordinator?.navigate(to: .showMap(longitude: longitude, latitude: latitude))
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

    /// If searchBar text is empty & user has already select an area, then update filters
    func didDismissSearchController(_ searchController: UISearchController) {
        if searchController.searchBar.text?.isEmpty == true && viewModel?.filters.areaIsFilled == true {
            self.viewModel?.filters.resetArea()
        }
    }

    func didSelectPlace(_ name: String, latitude: Double, longitude: Double) {
        searchController.searchBar.text = name
        searchController.dismiss(animated: true)

        viewModel?.filters.addArea(longitude: longitude, latitude: latitude)
    }
}

// MARK: - CollectionView Delegates
extension HomeVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, SkeletonCollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyOpportunityCell.identifier, for: indexPath) as! MyOpportunityCell

        if let model = viewModel?.data[safe: indexPath.row] {
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
        if let opportunitiesCurrentNum = viewModel?.data.count, opportunitiesCurrentNum > 0 {
            return opportunitiesCurrentNum
        }
        return  2
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return MyOpportunityCell.identifier
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 48, height: 300)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let opportunityId = viewModel?.data[safe: indexPath.row]?.opportunityId else {
            return
        }

        self.coordinator?.navigate(to: .showDetails(opportunityId, animated: true))
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard viewModel?.collectionViewIsUpdating == false,
              viewModel?.noMoreOpportunities == false,
              viewModel?.errorMessage == nil else {
            return
        }

        if targetContentOffset.pointee.y >= (collectionView.contentSize.height - collectionView.frame.size.height) - 1000 {

            viewModel?.getOpportunities(withFilters: viewModel?.filters)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: OpportunitiesFooterView.identifier, for: indexPath)

            return footerView
        default:
            fatalError("Unexpected element kind")
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return (viewModel?.noMoreOpportunities == false) ? CGSize(width: 48.0, height: 48.0) : .zero
    }

}
