//
//  HomeCoordinator.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 17/6/22.
//

import UIKit
import SharedKit

/** A Coordinator which is responsible about  main `Home Page`. */

final class HomeCoordinator: NavigationCoordinator {

    var parent: TabBarCoordinator
    var childCoordinators: [Coordinator] = []
    var navigator: NavigatorType
    var rootViewController: UINavigationController

    init(_ parent: TabBarCoordinator) {
        self.parent = parent

        let homePage = HomeVC()
        homePage.viewModel = HomeViewModel()

        let navigationController = UINavigationController(rootViewController: homePage)

        self.navigator = Navigator(navigationController: navigationController)
        self.rootViewController = navigationController
        homePage.coordinator = self
    }

    func start() {}

}
