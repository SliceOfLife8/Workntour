//
//  ProfileCoordinator.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 17/6/22.
//

import UIKit
import SharedKit

/** A Coordinator which is responsible about profile section for `Hosts` & `Travelers` . */

final class ProfileCoordinator: NavigationCoordinator {

    var parent: TabBarCoordinator
    var childCoordinators: [Coordinator] = []
    var navigator: NavigatorType
    var rootViewController: UINavigationController

    private var userRole: UserRole?

    init(_ parent: TabBarCoordinator) {
        self.parent = parent
        self.userRole = UserDataManager.shared.role

        let navigationController = UINavigationController()
        self.navigator = Navigator(navigationController: navigationController)
        self.rootViewController = navigationController
    }

    func start() {
        if userRole == .TRAVELER {
            let travelerVC = TravelerProfileVC()
            travelerVC.viewModel = TravelerProfileViewModel()
            travelerVC.coordinator = self

            navigator.push(travelerVC, animated: true)
        } else {
            let hostVC = HostProfileVC(userRole == .COMPANY_HOST)
            hostVC.viewModel = HostProfileViewModel()
            hostVC.coordinator = self

            navigator.push(hostVC, animated: true)
        }
    }

}
