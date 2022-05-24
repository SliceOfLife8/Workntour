//
//  MainCoordinator.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import UIKit
import SharedKit

enum MainStep: Step {
    case registerPoint
}

// MARK: - MainCoordinator
final class MainCoordinator: NavigationCoordinator {

    var parent: AppCoordinator
    var childCoordinators: [Coordinator] = []
    var navigator: NavigatorType
    var rootViewController: UINavigationController

    init(parent: AppCoordinator) {
        self.parent = parent

        let navigationController = UINavigationController()
        self.navigator = Navigator(navigationController: navigationController)
        self.rootViewController = navigationController
    }

    func start() {
        let splashViewModel = SplashViewModel()
        let splashVC = SplashVC()

        splashVC.viewModel = splashViewModel
        splashVC.coordinator = self

        self.rootViewController.pushViewController(splashVC, animated: true)
    }

    func navigate(to step: MainStep) {
        switch step {
        case .registerPoint:
            let registrationVC = RegistrationVC()
            registrationVC.viewModel = RegistrationViewModel()
            registrationVC.coordinator = self

            self.rootViewController.pushViewController(registrationVC, animated: true)
        }
    }
}
