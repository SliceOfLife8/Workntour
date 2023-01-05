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
import BottomSheet

enum LoginStep: Step {
    case state(_ default: DefaultStep)
    case successfulLogin
    case register
    case forgotPassword
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
        case .state(.showAlert(let title, let subtitle)):
            AlertHelper.showDefaultAlert(
                rootViewController,
                title: title,
                message: subtitle
            )
        case .state(.back):
            parent.dismissCoordinator(self, modalStyle: .coverVertical, animated: true)
        case .successfulLogin:
            parent.dismissCoordinator(self, modalStyle: .coverVertical, animated: false, completion: {
                DispatchQueue.main.async {
                    self.parent.showMainFlow()
                }
            })
        case .register:
            showAlert()
        case .forgotPassword:
            requestPasswordLink()
        }
    }

    func showAlert() {
        AlertHelper.showAlertWithTwoActions(
            rootViewController,
            title: "sign_up_as".localized(),
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

    private func requestPasswordLink() {
        let requestLinkVC = ForgotPasswordRequestLinkVC()
        requestLinkVC.viewModel = ForgotPasswordRequestLinkViewModel()
        requestLinkVC.coordinator = self

        rootViewController.presentBottomSheet(
            viewController: requestLinkVC,
            configuration: BottomSheetConfiguration(
                cornerRadius: 16,
                pullBarConfiguration: .visible(.init(height: 20)),
                shadowConfiguration: .init(backgroundColor: UIColor.black.withAlphaComponent(0.6))
            )
        )
    }
}
