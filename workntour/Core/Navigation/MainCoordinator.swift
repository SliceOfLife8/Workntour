//
//  MainCoordinator.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import UIKit
import SharedKit

enum MainStep: Step {
    case registrationPoint
    case login
    case loginAsGuest
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

        navigator.push(splashVC, animated: false)
    }

    func navigate(to step: MainStep) {
        switch step {
        case .registrationPoint:
            showAlert()
        case .login:
            startLoginFlow()
        case .loginAsGuest:
            showMainFlow()
        }
    }

    func showAlert() {
        AlertHelper.showAlertWithTwoActions(rootViewController, title: "Sign Up as a", leftButtonTitle: "Traveler", rightButtonTitle: "Host", leftAction: {
            self.startRegistrationFlow(forType: .TRAVELER)
        }, rightAction: {
            self.startRegistrationFlow(forType: .INDIVIDUAL_HOST)
        })
    }

    private func startRegistrationFlow(forType type: UserRole) {
        let registrationCoordinator = RegistrationCoordinator(parent: self, role: type)
        presentCoordinator(registrationCoordinator, modalStyle: .overFullScreen, animated: true)
    }

    private func startLoginFlow() {
        let loginCoordinator = LoginCoordinator(parent: self)
        pushCoordinator(loginCoordinator, animated: true)
    }

    /// Create TabBarCoordinator & set it as rootViewController of our main NavigationController
    func showMainFlow() {
        rootViewController.hideNavigationBar(false)
        let tabCoordinator = TabBarCoordinator(parent: self, rootViewController)
        pushCoordinator(tabCoordinator, animated: false)
        navigator.setRootViewController(tabCoordinator.rootViewController, animated: false)
    }
}
