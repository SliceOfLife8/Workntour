//
//  HomeCoordinator.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 17/6/22.
//

import UIKit
import SharedKit

enum HomePageStep: Step {
    case state(_ default: DefaultStep)
    case showMap(longitude: Double, latitude: Double)
    case showFilters
    case showDetails(_ opportunityId: String, animated: Bool)
    case showDatePicker
    case saveDateRangeSelection(from: String, to: String)
    case updateFilters(_ filters: OpportunityFilterDto)
}

/** A Coordinator which is responsible about  main `Home Page`. */

final class HomeCoordinator: NavigationCoordinator {

    var parent: TabBarCoordinator
    var childCoordinators: [Coordinator] = []
    var navigator: NavigatorType
    var rootViewController: UINavigationController
    var homePage: HomeVC

    init(_ parent: TabBarCoordinator) {
        self.parent = parent

        homePage = HomeVC()
        homePage.viewModel = HomeViewModel()

        let navigationController = UINavigationController(rootViewController: homePage)

        self.navigator = Navigator(navigationController: navigationController)
        self.rootViewController = navigationController
        homePage.coordinator = self
    }

    func start() {}

    func navigate(to step: HomePageStep) {
        switch step {
        case .state(.back):
            navigator.popViewController(animated: true)
        case .state(.showAlert(let title, let subtitle)):
            AlertHelper.showDefaultAlert(rootViewController,
                                         title: title,
                                         message: subtitle)
        case .showMap(let long, let lat):
            openMap(longitude: long, latitude: lat)
        case .showFilters:
            openFilters()
        case .showDetails(let opportunityId, let animated):
            openDetailsView(id: opportunityId, animated: animated)
        case .showDatePicker:
            openDatePicker()
        case .saveDateRangeSelection(let start, let end):
            if let filtersNav = rootViewController.presentedViewController as? UINavigationController, let filtersVC = filtersNav.previousViewController as? OpportunitiesFiltersVC {
                filtersNav.popViewController(animated: true)
                filtersVC.updateDateLabel(start: start, end: end)
            }
        case .updateFilters(let filters):
            homePage.viewModel?.filters = filters
        }
    }

    private func openFilters() {
        let filters = OpportunitiesFiltersVC()
        filters.viewModel = OpportunitiesFiltersViewModel(filters: homePage.viewModel?.filters,
                                                          totalOpportunities: homePage.viewModel?.totalNumOfOpportunities ?? 0)
        filters.coordinator = self
        filters.modalPresentationStyle = .popover

        let filtersNavigationController = UINavigationController(rootViewController: filters)
        self.rootViewController.present(filtersNavigationController, animated: true, completion: {
            // Disable presentedView -- https://developer.apple.com/documentation/uikit/uipresentationcontroller/1618321-presentedview
            filtersNavigationController.presentationController?.presentedView?.gestureRecognizers?.first?.isEnabled = false
        })
    }

    private func openDetailsView(id: String, animated: Bool) {
        let vc = OpportunityDetailsVC(id)
        vc.viewModel = OpportunitesDetailsViewModel()
        vc.otherCoordinator = self
        vc.hidesBottomBarWhenPushed = true
        navigator.push(vc, animated: animated)
    }

    private func openDatePicker() {
        let selectDates = SelectDateRangesVC()
        selectDates.otherCoordinator = self

        if let filtersNav = rootViewController.presentedViewController as? UINavigationController {
            filtersNav.pushViewController(selectDates, animated: true)
        }
    }

    private func openMap(longitude: Double, latitude: Double) {
        let mapVC = MapOfOpportunitiesVC()
        mapVC.viewModel = MapOfOpportunitiesViewModel(longitude: longitude,
                                                      latitude: latitude)
        mapVC.coordinator = self
        mapVC.hidesBottomBarWhenPushed = true
        navigator.push(mapVC, animated: true)
    }

}
