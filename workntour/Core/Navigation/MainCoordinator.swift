//
//  MainCoordinator.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import UIKit
import SharedKit

enum MainStep: Step {
   case registerPoint
}

// MARK: - MainCoordinator
final class MainCoordinator: NavigationCoordinator {

    var parent: AppCoordinator
    var childCoordinators: [Coordinator] = []
    var navigator: NavigatorType
    var rootViewController: UINavigationController

    private let entryViewController: UIViewController

    init(parent: AppCoordinator) {
        self.parent = parent

        let splashViewModel = SplashViewModel()
        let splashVC = SplashVC()
        splashVC.viewModel = splashViewModel

        self.entryViewController = splashVC

        let navigationController = UINavigationController(rootViewController: entryViewController)
        self.navigator = Navigator(navigationController: navigationController)
        self.rootViewController = navigationController
        splashVC.coordinator = self
    }

    func start() {
        // rootViewController.delegate = self
    }

    func something() {
        parent.dismissCoordinator(self, animated: true)
    }

    func navigate(to step: MainStep) {
        switch step {
        case .registerPoint:
            print("register point!!!")
        }
    }
}
