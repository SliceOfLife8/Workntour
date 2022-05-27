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
        let registrationViewModel = RegistrationViewModel()
        let registrationVC = RegistrationVC()

        registrationVC.viewModel = registrationViewModel
        registrationVC.coordinator = self

        rootViewController.pushViewController(registrationVC, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
           // self.navigate(to: .close)
        })
    }

    func navigate(to step: RegistrationStep) {
        switch step {
        case .emailVerification:
            debugPrint("Open verification!")
        case .close:
            dismissCoordinator(self, modalStyle: .coverVertical, animated: true, completion: nil)
        }
    }

}
