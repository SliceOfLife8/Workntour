//
//  SearchLocationsVC.swift
//  workntour
//
//  Created by Chris Petimezas on 21/6/22.
//

import UIKit
import SharedKit
import CoreLocation
import SnapKit

protocol SearchLocationsDelegate: AnyObject {
    func didStartEditing()
    func findLocation(didSelectLocationWith coordinates: CLLocationCoordinate2D?, area: PlacemarkAttributes?)
}

class SearchLocationsVC: UIViewController {

    // MARK: - Vars
    weak var delegate: SearchLocationsDelegate?

    private lazy var mainTitle: UILabel = {
        let label = UILabel()
        label.text = "Where to?"
        label.font = UIFont.scriptFont(.bold, size: 22)
        return label
    }()

    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Enter destination"
        search.layer.cornerRadius = 9
        search.backgroundColor = .tertiarySystemGroupedBackground
        search.backgroundImage = UIImage()
        return search
    }()

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.tableFooterView = UIView()
        table.backgroundColor = .secondarySystemBackground
        return table
    }()

    var locations = [Location]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondarySystemBackground
        view.makeCorner(withRadius: 8)
        setupUI()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }

    private func setupUI() {
        [mainTitle, searchBar, tableView].forEach {
            view.addSubview($0)
        }

        mainTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(24)
        }

        searchBar.snp.makeConstraints {
            $0.top.equalTo(mainTitle.snp.bottom).offset(8)
            $0.left.equalTo(mainTitle.snp.left)
            $0.right.equalToSuperview().offset(-16)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().offset(-16)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
    }

}

// MARK: - TableViewDelegates
extension SearchLocationsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = locations[indexPath.row].placemark?.formattedName(userIsHost: true)
        cell.textLabel?.numberOfLines = 0
        cell.contentView.backgroundColor = .secondarySystemBackground
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Notify map controller to show pin at selected place
        let location = locations[indexPath.row]
        searchBar.resignFirstResponder()
        delegate?.findLocation(didSelectLocationWith: location.coordinates, area: location.placemark)
    }
}

// MARK: - UISearchBarDelegate
extension SearchLocationsVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            LocationManager.shared.findLocations(with: text) { [weak self] locations in
                if !locations.isEmpty {
                    searchBar.resignFirstResponder()
                }
                DispatchQueue.main.async {
                    self?.locations = locations
                    self?.tableView.reloadData()
                }
            }
        }
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        delegate?.didStartEditing()
        return true
    }
}
