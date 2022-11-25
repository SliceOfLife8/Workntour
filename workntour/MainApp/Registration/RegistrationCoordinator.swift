//
//  RegistrationCoordinator.swift
//  workntour
//
//  Created by Chris Petimezas on 27/5/22.
//

import UIKit
import SharedKit
import Combine

enum RegistrationStep: Step {
    case emailVerification(email: String)
    case errorDialog(description: String)
    case close
}

/** A Coordinator which takes a user through the registration flow. */

final class RegistrationCoordinator: NavigationCoordinator {

    var parent: Coordinator
    var childCoordinators: [Coordinator] = []
    var navigator: NavigatorType
    var rootViewController: UINavigationController

    private var userRole: UserRole

    init(parent: Coordinator, role: UserRole) {
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
        case .emailVerification(let email):
            openEmailVerification(email)
        case .close:
            /* TODO: This is a temporary solution!
             Please find a proper one... */
            if let _parent = parent as? MainCoordinator {
                _parent.dismissCoordinator(self, modalStyle: .coverVertical, animated: true, completion: nil)
            } else if let _parent = parent as? LoginCoordinator {
                _parent.dismissCoordinator(self, modalStyle: .coverVertical, animated: true, completion: nil)
            }
        case .errorDialog(let description):
            AlertHelper.showDefaultAlert(rootViewController, title: "Error message", message: description)
        }
    }

    private func travelerRegistration() {
        let registrationViewModel = RegistrationTravelerViewModel()
        let registrationVC = RegistrationTravelerVC()

        registrationVC.viewModel = registrationViewModel
        registrationVC.coordinator = self

        navigator.push(registrationVC, animated: true)
    }

    private func openEmailVerification(_ email: String) {
        let verificationViewModel = EmailVerificationViewModel()
        let emailVerificationVC = EmailVerificationVC(email)

        emailVerificationVC.viewModel = verificationViewModel
        emailVerificationVC.coordinator = self

        navigator.push(emailVerificationVC, animated: true)
    }

    private func hostRegistration() {
        let registrationViewModel = RegistrationHostViewModel()
        let hostVC = RegistrationHostVC()

        hostVC.viewModel = registrationViewModel
        hostVC.coordinator = self

        navigator.push(hostVC, animated: true)
    }

}
