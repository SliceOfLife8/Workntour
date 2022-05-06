//
//  OnboardingCoordinator.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
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

    // private let onboardingViewModel: OnboardingViewModel

    init() {
        // onboardingViewModel = OnboardingViewModel()
        // let onboardingVC = OnboardingVC(onboardingViewModel)

        let navigationController = UINavigationController(rootViewController: UIViewController())
        navigationController.navigationBar.isHidden = true
        self.navigator = Navigator(navigationController: navigationController)
        self.rootViewController = navigationController
    }

    func start() {
        // onboardingViewModel.delegate = self
    }

}
