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
        guard let mainCoordinator = childCoordinators.first as? MainCoordinator else { return }

        mainCoordinator.rootViewController.topViewController?.presentedViewController?.dismiss(animated: false)

        switch route {
        case .forgotPasswordVerification(let token):
            setupNewCredentials(withToken: token)
        case .verifyRegistration(let token):
            EmailVerificationUseCase(
                token: token,
                rootViewController: rootViewController,
                mainCoordinator: mainCoordinator
            ).verify()
        }
    }

    private func setupNewCredentials(withToken token: String) {
        let setupCredsVC = SetupNewCredentialsVC()
        setupCredsVC.viewModel = SetupNewCredentialsViewModel(data: .init(token: token))
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
}
