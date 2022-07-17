//
//  HomeCoordinator.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 17/6/22.
//

import UIKit
import SharedKit

enum HomePageStep: Step {
    case showMap
    case showFilters
    case showDetails(_ opportunityId: String)
}

/** A Coordinator which is responsible about  main `Home Page`. */

final class HomeCoordinator: NavigationCoordinator {

    var parent: TabBarCoordinator
    var childCoordinators: [Coordinator] = []
    var navigator: NavigatorType
    var rootViewController: UINavigationController

    init(_ parent: TabBarCoordinator) {
        self.parent = parent

        let homePage = HomeVC()
        homePage.viewModel = HomeViewModel()

        let navigationController = UINavigationController(rootViewController: homePage)

        self.navigator = Navigator(navigationController: navigationController)
        self.rootViewController = navigationController
        homePage.coordinator = self
    }

    func start() {}

    func navigate(to step: HomePageStep) {
        switch step {
        case .showMap:
            let mapVC = MapViewController()
            // mapVC.coordinator = self
            mapVC.modalPresentationStyle = .popover
            self.rootViewController.present(mapVC, animated: true)
        case .showFilters:
            openFilters()
        case .showDetails(let opportunityId):
            openDetailsView(id: opportunityId)
        }
    }

    private func openFilters() {
        let filters = OpportunitiesFiltersVC()
        filters.viewModel = OpportunitiesFiltersViewModel()
        filters.coordinator = self
        filters.modalPresentationStyle = .popover
        let filtersNavigationController = UINavigationController(rootViewController: filters)
        self.rootViewController.present(filtersNavigationController, animated: true, completion: {
            // Disable presentedView -- https://developer.apple.com/documentation/uikit/uipresentationcontroller/1618321-presentedview
            filtersNavigationController.presentationController?.presentedView?.gestureRecognizers?.first?.isEnabled = false
        })
    }

    private func openDetailsView(id: String) {
        let vc = OpportunityDetailsVC(id)
        vc.viewModel = OpportunitesDetailsViewModel()
        // vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        navigator.push(vc, animated: true)
    }

}
