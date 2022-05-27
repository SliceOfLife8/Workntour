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

        self.rootViewController.pushViewController(splashVC, animated: true)
    }

    func navigate(to step: MainStep) {
        switch step {
        case .registrationPoint:
            showAlert()
        case .login:
            debugPrint("Login flow!")
        case .loginAsGuest:
            debugPrint("Login as a guest!")
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
}
