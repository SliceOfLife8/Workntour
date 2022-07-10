//
//  SearchOpportunitiesVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 8/7/22.
//

import UIKit
import SharedKit

protocol OpportunitiesResultsDelegate: AnyObject {
    func didSelectPlace(_ name: String, latitude: Double, longitude: Double)
}

class OpportunitiesResultsVC: UIViewController {

    weak var delegate: OpportunitiesResultsDelegate?

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorStyle = .none
        return table
    }()

    private var places: [Place] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    public func update(with places: [Place]) {
        self.places = places
        tableView.reloadData()
    }
}

extension OpportunitiesResultsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        cell.backgroundColor = UIColor.appColor(.primary)
        cell.textLabel?.textColor = .black
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let place = places[indexPath.row]

        GooglePlacesManager.shared.resolveLocation(for: place) { result in
            switch result {
            case .success(let coordinate):
                self.delegate?.didSelectPlace(place.name, latitude: coordinate.latitude, longitude: coordinate.longitude)
            case .failure(let error):
                print("Handle this scenario \(error)!")
            }
        }
    }
}
