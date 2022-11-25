//
//  NotificationsCoordinator.swift
//  workntour
//
//  Created by Chris Petimezas on 17/6/22.
//

import UIKit
import SharedKit

/** A Coordinator which is responsible about  Notifications of our app. */

final class NotificationsCoordinator: NavigationCoordinator {

    var parent: TabBarCoordinator
    var childCoordinators: [Coordinator] = []
    var navigator: NavigatorType
    var rootViewController: UINavigationController

    init(_ parent: TabBarCoordinator) {
        self.parent = parent

        let notifications = NotificationsVC()
        notifications.viewModel = NotificationsViewModel()

        let navigationController = UINavigationController(rootViewController: notifications)

        self.navigator = Navigator(navigationController: navigationController)
        self.rootViewController = navigationController
        notifications.coordinator = self
    }

    func start() {}

}
