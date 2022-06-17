//
//  OpportunitiesCoordinator.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 16/6/22.
//

import UIKit
import SharedKit

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

}
