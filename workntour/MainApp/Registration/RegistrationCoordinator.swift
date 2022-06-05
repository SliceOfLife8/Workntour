//
//  RegistrationCoordinator.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 27/5/22.
//

import UIKit
import SharedKit

enum RegistrationStep: Step {
    case emailVerification
    case close
}

/** A Coordinator which takes a user through the registration flow. */

final class RegistrationCoordinator: NavigationCoordinator {

    var parent: MainCoordinator
    var childCoordinators: [Coordinator] = []
    var navigator: NavigatorType
    var rootViewController: UINavigationController

    private var userRole: UserRole

    init(parent: MainCoordinator, role: UserRole) {
        self.parent = parent
        self.userRole = role

        let navigationController = UINavigationController()
        self.navigator = Navigator(navigationController: navigationController)
        self.rootViewController = navigationController
    }

    func start() {
        if userRole == .TRAVELER {
            travelerRegistration()
        } else {
            hostRegistration()
        }
    }

    func navigate(to step: RegistrationStep) {
        switch step {
        case .emailVerification:
            debugPrint("Open verification!")
        case .close:
            parent.dismissCoordinator(self, modalStyle: .coverVertical, animated: true, completion: nil)
        }
    }

    private func travelerRegistration() {
        let registrationViewModel = RegistrationTravelerViewModel()
        let registrationVC = RegistrationTravelerVC()

        registrationVC.viewModel = registrationViewModel
        registrationVC.coordinator = self

        rootViewController.pushViewController(registrationVC, animated: true)
    }

    private func hostRegistration() {
        print("to be done!")
    }

}
