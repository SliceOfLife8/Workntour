//
//  OpportunitiesCoordinator.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 16/6/22.
//

import UIKit
import SharedKit

enum OpportunitiesStep: Step {
    case showMap
    case closeMap
    case saveLocation(name: String?, latitude: Double, longitude: Double)
}

/** A Coordinator which takes a `Host` through the opportunities flow. */

final class OpportunitiesCoordinator: NavigationCoordinator {

    var parent: TabBarCoordinator
    var childCoordinators: [Coordinator] = []
    var navigator: NavigatorType
    var rootViewController: UINavigationController

    init(_ parent: TabBarCoordinator) {
        self.parent = parent

        let opportunities = OpportunitiesVC()
        opportunities.viewModel = OpportunitiesViewModel()

        let navigationController = UINavigationController(rootViewController: opportunities)

        self.navigator = Navigator(navigationController: navigationController)
        self.rootViewController = navigationController
        opportunities.coordinator = self
    }

    func start() {}

    func navigate(to step: OpportunitiesStep) {
        switch step {
        case .showMap:
            let mapVC = MapViewController()
            mapVC.coordinator = self
            mapVC.modalPresentationStyle = .overFullScreen
            self.rootViewController.present(mapVC, animated: true)
        case .closeMap:
            self.rootViewController.dismiss(animated: true)
        case .saveLocation(let name, let latitude, let longitude):
            print("SaveLocation: \(String(describing: name)) \(latitude) \(longitude)")
            self.navigate(to: .closeMap)
        }
    }

}
