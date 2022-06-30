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
    case openGalleryPicker
    case saveLocation(name: String?, latitude: Double, longitude: Double)
    case openCalendar
    case saveDataRangeSelection(from: String, to: String)
    case back
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
        case .saveLocation(let name, let latitude, let longitude):
            print("SaveLocation: \(String(describing: name)) \(latitude) \(longitude)")
            guard let address = name else {
                assertionFailure("Address should be always filled!")
                return
            }
            let location = OpportunityLocation(title: address, latitude: latitude, longitude: longitude)
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
