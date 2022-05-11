//
//  MainCoordinator.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import UIKit
import SharedKit

// MARK: - MainCoordinator
final class MainCoordinator: NavigationCoordinator {

    var childCoordinators: [Coordinator] = []
    var navigator: NavigatorType
    var rootViewController: UINavigationController

    private let entryViewController: UIViewController

    init() {
        let viewModel = SplashViewModel()
        self.entryViewController = SplashVC(viewModel)

        let navigationController = UINavigationController(rootViewController: entryViewController)
        self.navigator = Navigator(navigationController: navigationController)
        self.rootViewController = navigationController
    }

    func start() {
        // rootViewController.delegate = self
    }

}
