//
//  SettingsCoordinator.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 17/6/22.
//

import UIKit
import SharedKit

enum SettingsStep: Step {
    case logout
}

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

    func navigate(to step: SettingsStep) {
        switch step {
        case .logout:
            logoutAlert()
        }
    }

    private func logoutAlert() {
        AlertHelper.showAlertWithTwoActions(rootViewController, title: "Are you sure you want to logout?", message: nil, leftButtonTitle: "Yes", rightButtonTitle: "No", leftAction: {
            self.parent.removeCoordinator()
        }, rightAction: {
            let settingsTableView = self.rootViewController.visibleViewController?.view.subviews.filter { $0 is UITableView }.first as? UITableView
            settingsTableView?.selectRow(at: nil, animated: false, scrollPosition: .none)
        })
    }

}
