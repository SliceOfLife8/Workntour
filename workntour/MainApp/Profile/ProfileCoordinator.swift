//
//  ProfileCoordinator.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 17/6/22.
//

import UIKit
import SharedKit

/** A Coordinator which is responsible about profile section for `Hosts` & `Travelers` . */

final class ProfileCoordinator: NavigationCoordinator {

    var parent: TabBarCoordinator
    var childCoordinators: [Coordinator] = []
    var navigator: NavigatorType
    var rootViewController: UINavigationController

    init(_ parent: TabBarCoordinator) {
        self.parent = parent

        let opportunitiesVC = TravelerProfileVC()
        opportunitiesVC.viewModel = TravelerProfileViewModel()

        let navigationController = UINavigationController(rootViewController: opportunitiesVC)

        self.navigator = Navigator(navigationController: navigationController)
        self.rootViewController = navigationController
        opportunitiesVC.coordinator = self
    }

    func start() {}

}
