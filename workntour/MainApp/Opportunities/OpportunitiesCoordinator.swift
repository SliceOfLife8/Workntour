//
//  OpportunitiesCoordinator.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 16/6/22.
//

import UIKit
import SharedKit
import PhotosUI

enum OpportunitiesStep: Step {
    case showMap
    case closeMap
    case createOpportunity
    case showDetailsView
    case openGalleryPicker
    case saveLocation(attribute: PlacemarkAttributes?, latitude: Double, longitude: Double)
    case openCalendar
    case saveDataRangeSelection(from: String, to: String)
    case back
    case showAlert(title: String, subtitle: String?)
    case opportunityWasCreated
    case deleteOpportunity
}

/** A Coordinator which takes a `Host` through the opportunities flow. */

final class OpportunitiesCoordinator: NavigationCoordinator {

    var parent: TabBarCoordinator
    var childCoordinators: [Coordinator] = []
    var navigator: NavigatorType
    var rootViewController: UINavigationController

    init(_ parent: TabBarCoordinator) {
        self.parent = parent

        let opportunities = OpportunitiesVC()
        opportunities.viewModel = OpportunitiesViewModel()

        let navigationController = UINavigationController(rootViewController: opportunities)

        self.navigator = Navigator(navigationController: navigationController)
        self.rootViewController = navigationController
        opportunities.coordinator = self
    }

    func start() {}

    // swiftlint:disable cyclomatic_complexity
    func navigate(to step: OpportunitiesStep) {
        switch step {
        case .back:
            navigator.popViewController(animated: true)
        case .showMap:
            let mapVC = MapViewController()
            mapVC.coordinator = self
            mapVC.modalPresentationStyle = .overFullScreen
            self.rootViewController.present(mapVC, animated: true)
        case .closeMap:
            self.rootViewController.dismiss(animated: true)
        case .saveLocation(let attributes, let latitude, let longitude):
            let location = OpportunityLocation(placemark: attributes, latitude: latitude, longitude: longitude)
            let opportunityVC = rootViewController.topViewController as? CreateOpportunityVC
            opportunityVC?.setupAddress(location: location)
            self.navigate(to: .closeMap)
        case .createOpportunity:
            createOpportunityScene()
        case .openGalleryPicker:
            openPhotoPicker()
        case .openCalendar:
            openHorizonCalendar()
        case .saveDataRangeSelection(let start, let end):
            let previousVC = rootViewController.previousViewController as? CreateOpportunityVC
            previousVC?.setupAvailableDates(from: start, to: end)
            navigator.popViewController(animated: true)
        case .showAlert(let title, let subtitle):
            AlertHelper.showDefaultAlert(rootViewController,
                                         title: title,
                                         message: subtitle)
        case .opportunityWasCreated:
            let previousVC = rootViewController.previousViewController as? OpportunitiesVC
            previousVC?.viewModel?.fetchModels()
            navigator.popViewController(animated: true)
        case .showDetailsView:
            openOpportunityDetailsMode()
        case .deleteOpportunity:
            deleteOpportunityAlert()
        }
    }

    private func createOpportunityScene() {
        let createOpportunityVC = CreateOpportunityVC()
        createOpportunityVC.viewModel = CreateOpportunityViewModel()
        createOpportunityVC.coordinator = self

        navigator.push(createOpportunityVC, animated: true)
    }

    private func openPhotoPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 7

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        rootViewController.present(picker, animated: true)
    }

    private func openHorizonCalendar() {
        let selectDates = SelectDateRangesVC()
        selectDates.coordinator = self
        selectDates.hidesBottomBarWhenPushed = true
        navigator.push(selectDates, animated: true)
    }

    private func openOpportunityDetailsMode() {
        let vc = OpportunityDetailsVC()
        vc.viewModel = OpportunitesDetailsViewModel()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        navigator.push(vc, animated: true)
    }

    private func deleteOpportunityAlert() {
        AlertHelper.showAlertWithTwoActions(rootViewController, title: "Delete this opportunity", leftButtonTitle: "Cancel", leftButtonStyle: .cancel, rightButtonTitle: "OK", leftAction: {}, rightAction: {
            let detailsVC = self.rootViewController.topViewController as? OpportunityDetailsVC
            detailsVC?.viewModel?.deleteOpportunity()
        })
    }

}

extension OpportunitiesCoordinator: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) // dismiss a picker

        let imageItems = results
            .map { $0.itemProvider }
            .filter { $0.canLoadObject(ofClass: UIImage.self) } // filter for possible UIImages

        let dispatchGroup = DispatchGroup()
        var images = [UIImage]()

        for imageItem in imageItems {
            dispatchGroup.enter()

            imageItem.loadObject(ofClass: UIImage.self) { image, _ in
                if let image = image as? UIImage {
                    images.append(image)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            let opportunityVC = self.rootViewController.topViewController as? CreateOpportunityVC
            opportunityVC?.viewModel?.images = images
            opportunityVC?.viewModel?.updateProgressBar()
        }
    }
}
