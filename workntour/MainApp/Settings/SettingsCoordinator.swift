//
//  SettingsCoordinator.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 17/6/22.
//

import UIKit
import SharedKit

/** A Coordinator which is responsible about  Settings. */

final class SettingsCoordinator: NavigationCoordinator {

    var parent: TabBarCoordinator
    var childCoordinators: [Coordinator] = []
    var navigator: NavigatorType
    var rootViewController: UINavigationController

    init(_ parent: TabBarCoordinator) {
        self.parent = parent

        let settings = SettingsVC()
        settings.viewModel = SettingsViewModel()

        let navigationController = UINavigationController(rootViewController: settings)

        self.navigator = Navigator(navigationController: navigationController)
        self.rootViewController = navigationController
        settings.coordinator = self
    }

    func start() {}

}
