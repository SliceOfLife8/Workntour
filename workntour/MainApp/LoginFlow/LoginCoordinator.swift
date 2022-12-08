//
//  LoginCoordinator.swift
//  workntour
//
//  Created by Chris Petimezas on 9/6/22.
//

import UIKit
import SharedKit
import Combine
import SwiftyBeaver

enum LoginStep: Step {
    case successfulLogin
    case close
    case register
    case forgotPassword
    case errorDialog(description: String)
}

/** A Coordinator which takes a user through the login flow. */

final class LoginCoordinator: PresentationCoordinator {

    var parent: MainCoordinator
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController

    init(parent: MainCoordinator) {
        self.parent = parent

        let loginVC = LoginVC()
        loginVC.viewModel = LoginViewModel()

        self.rootViewController = loginVC
        loginVC.coordinator = self
    }

    func start() {
        SwiftyBeaver.info("Login Flow started!")
    }

    func navigate(to step: LoginStep) {
        switch step {
        case .successfulLogin:
            parent.dismissCoordinator(self, modalStyle: .coverVertical, animated: false, completion: {
                DispatchQueue.main.async {
                    self.parent.showMainFlow()
                }
            })
        case .close:
            parent.dismissCoordinator(self, modalStyle: .coverVertical, animated: true, completion: nil)
        case .register:
            showAlert()
        case .forgotPassword:
            print("Not for MVP!")
        case .errorDialog(let description):
            AlertHelper.showDefaultAlert(rootViewController, title: "Error message", message: description)
        }
    }

    func showAlert() {
        AlertHelper.showAlertWithTwoActions(
            rootViewController,
            title: "sign_up".localized(),
            hasCancelOption: true,
            leftButtonTitle: "traveler".localized(),
            rightButtonTitle: "host".localized(),
            leftAction: {
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
