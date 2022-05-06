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

    // private let examplesViewController: SideMenuController

    init() {
        // Add tabbar coordinator
        // let examplesViewController = SideMenuController(contentViewController: HomePageVC(), menuViewController: SideMenuVC())
        // self.examplesViewController = examplesViewController

        let navigationController = UINavigationController(rootViewController: UIViewController())
        self.navigator = Navigator(navigationController: navigationController)
        self.rootViewController = navigationController
    }

    func start() {
        // rootViewController.delegate = self
    }

}
