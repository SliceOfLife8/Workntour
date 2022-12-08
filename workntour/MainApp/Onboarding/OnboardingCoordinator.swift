//
//  OnboardingCoordinator.swift
//  workntour
//
//  Created by Chris Petimezas on 1/5/22.
//

import UIKit
import SharedKit

// MARK: - Delegate
protocol OnboardingCoordinatorDelegate: AnyObject {
    func onboardingCoordinatorDidFinish(_ coordinator: OnboardingCoordinator, userIsGranted: Bool)
}

// MARK: - Coordinator
/** A Coordinator which takes a user through the first-time user / onboarding flow. */

final class OnboardingCoordinator: NavigationCoordinator {

    weak var delegate: OnboardingCoordinatorDelegate?

    var childCoordinators: [Coordinator] = []
    var navigator: NavigatorType
    var rootViewController: UINavigationController

    init() {
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        self.navigator = Navigator(navigationController: navigationController)
        self.rootViewController = navigationController
    }

    func start() {
        let onboardingVC = OnboardingVC()
        onboardingVC.viewModel = OnboardingViewModel()
        onboardingVC.coordinator = self

        navigator.push(onboardingVC, animated: false)
    }
}
