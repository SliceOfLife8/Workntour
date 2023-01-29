//
//  AppCoordinator.swift
//  workntour
//
//  Created by Chris Petimezas on 1/5/22.
//

import UIKit
import SharedKit
import BottomSheet
import CommonUI

/** The application's root `Coordinator`. */

final class AppCoordinator: PresentationCoordinator {

    var childCoordinators: [Coordinator] = []
    var rootViewController = AppRootVC()

    init(window: UIWindow) {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        DeepLinkManager.shared.delegate = self
    }

    func start() {
        if LocalStorageManager.shared.retrieve(
            forKey: .onboarding,
            type: Bool.self
        ) == true {
            route(isFirstTimeUser: false)
        }
        else {
            route(isFirstTimeUser: true)
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
        LocalStorageManager.shared.save(
            true,
            forKey: .onboarding,
            withMethod: .userDefaults
        )

        if userIsGranted {
            route(isFirstTimeUser: false)

            dismissCoordinator(coordinator, modalStyle: .flipHorizontal, animated: true)
        }
    }
}

// MARK: - DeepLinkManagerDelegate
extension AppCoordinator: DeepLinkManagerDelegate {

    func redirect(to route: DeepLinkRoute) {
        /// Remove all presented Coordinators!
        if let mainCoordinator = childCoordinators.first as? MainCoordinator {
            mainCoordinator.rootViewController.topViewController?.presentedViewController?.dismiss(animated: false)
        }

        switch route {
        case .forgotPasswordVerification:
            rootViewController.showLoader()

            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.rootViewController.stopLoader()
            })
            /*
             Create EmailVerificationUseCase to make network call
             & show either LinkExpiredVC nor SetupNewCredentialsVC
             */
            linkWasExpired()
        }
    }

    private func setupNewCredentials() {
        let setupCredsVC = SetupNewCredentialsVC()
        setupCredsVC.viewModel = SetupNewCredentialsViewModel()
        setupCredsVC.coordinator = self

        rootViewController.presentBottomSheet(
            viewController: setupCredsVC,
            configuration: BottomSheetConfiguration(
                cornerRadius: 16,
                pullBarConfiguration: .visible(.init(height: 20)),
                shadowConfiguration: .init(backgroundColor: UIColor.black.withAlphaComponent(0.6))
            )
        )
    }

    private func linkWasExpired() {
        let expiredVC = LinkExpiredVC()
        expiredVC.viewModel = LinkExpiredViewModel(data: .init(mode: .forgotPassword))
        expiredVC.coordinator = self

        rootViewController.presentBottomSheet(
            viewController: expiredVC,
            configuration: BottomSheetConfiguration(
                cornerRadius: 16,
                pullBarConfiguration: .visible(.init(height: 20)),
                shadowConfiguration: .init(backgroundColor: UIColor.black.withAlphaComponent(0.6))
            )
        )
    }
}
