//
//  AppCoordinator.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import UIKit
import SharedKit

/** The application's root `Coordinator`. */

final class AppCoordinator: PresentationCoordinator {

    var childCoordinators: [Coordinator] = []
    var rootViewController = AppRootVC()

    init(window: UIWindow) {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }

    func start() {
        let hasUserSeenOnboardingFlow = LocalStorageManager.shared.retrieve(forKey: .onboarding, type: Bool.self)

        if hasUserSeenOnboardingFlow == true {
            // Navigate him to the next screen
        } else {
            self.route(isFirstTimeUser: false)
        }
    }

}

// MARK: - Routing
private extension AppCoordinator {

    func route(isFirstTimeUser: Bool) {
        if isFirstTimeUser {
            let onboardingCoordinator = OnboardingCoordinator()
            onboardingCoordinator.delegate = self
            onboardingCoordinator.rootViewController.isModalInPresentation = true
            presentCoordinator(onboardingCoordinator, animated: false)
        } else {
            let mainCoordinator = MainCoordinator(parent: self)
            addChildCoordinator(mainCoordinator)
            mainCoordinator.start()
            rootViewController.set(childViewController: mainCoordinator.rootViewController)
        }
    }

}

// MARK: - Onboarding Coordinator Delegate
extension AppCoordinator: OnboardingCoordinatorDelegate {

    func onboardingCoordinatorDidFinish(_ coordinator: OnboardingCoordinator, userIsGranted: Bool) {
        LocalStorageManager.shared.save(true,
                                        forKey: .onboarding,
                                        withMethod: .userDefaults)

        if userIsGranted {
            route(isFirstTimeUser: false)

            dismissCoordinator(coordinator, modalStyle: .flipHorizontal, animated: true)
        } else {
            // something else
        }
    }

}
