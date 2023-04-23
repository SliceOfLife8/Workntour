//
//  OpportunitiesCoordinator.swift
//  workntour
//
//  Created by Chris Petimezas on 16/6/22.
//

import UIKit
import SharedKit
import PhotosUI

enum OpportunitiesStep: Step {
    case state(_ default: DefaultStep)
    case showMap
    case closeMap
    case createOpportunity(dataModel: CreateOpportunityViewModel.DataModel)
    case selectWorkingDaysHours(dates: OpportunitySelectDates?)
    case createOpportunityAddOptionals(_ optionals: OpportunityOptionals?)
    case showDetailsView(id: String)
    case openGalleryPicker
    case saveLocation(attribute: PlacemarkAttributes?, latitude: Double, longitude: Double)
    case openCalendar(dataModel: SelectDateRangesVC.DataModel)
    case saveDateRangeSelection(from: Date, to: Date)
    case updateOpportunitiesOnLanding
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
        case .state(.back):
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
            opportunityVC?.viewModel?.location = location
            self.navigate(to: .closeMap)
        case .createOpportunity(let model):
            createOpportunityScene(dataModel: model)
        case .createOpportunityAddOptionals(let optionals):
            additionalOfferings(optionals)
        case .selectWorkingDaysHours(let dates):
            let model = HostSelectDaysViewModel.DataModel(dates: dates)
            hostSelectDays(dataModel: model)
        case .openGalleryPicker:
            openPhotoPicker()
        case .openCalendar(let model):
            openHorizonCalendar(model)
        case .saveDateRangeSelection(let start, let end):
            let previousVC = rootViewController.previousViewController as? CreateOpportunityVC
            previousVC?.viewModel?.dates.append(CalendarDate(start: start, end: end))
            navigator.popViewController(animated: true)
        case .state(.showAlert(let title, let subtitle)):
            AlertHelper.showDefaultAlert(rootViewController,
                                         title: title,
                                         message: subtitle)
        case .updateOpportunitiesOnLanding:
            updateOpportunities()
        case .showDetailsView(let id):
            openOpportunityDetailsMode(opportunityId: id)
        case .deleteOpportunity:
            deleteOpportunityAlert()
        }
    }

    // MARK: - Internal Methods

    func setupDays(minDays: Int, maxDays: Int, workingHours: Int, daysOff: Int) {
        let previousVC = rootViewController.previousViewController as? CreateOpportunityVC
        previousVC?.viewModel?.workingDays = OpportunitySelectDates(
            minDays: minDays,
            maxDays: maxDays,
            workingHours: workingHours,
            daysOff: daysOff
        )
        navigator.popViewController(animated: true)
    }

    func addOpportunityExtraOfferings(optionals: OpportunityOptionals) {
        let previousVC = rootViewController.previousViewController as? CreateOpportunityVC
        previousVC?.viewModel?.additonalOfferings = optionals
        navigator.popViewController(animated: true)
    }

    // MARK: - Private Methods

    private func createOpportunityScene(dataModel: CreateOpportunityViewModel.DataModel) {
        let createOpportunityVC = CreateOpportunityVC()
        createOpportunityVC.viewModel = CreateOpportunityViewModel(dataModel: dataModel)
        createOpportunityVC.coordinator = self

        navigator.push(createOpportunityVC, animated: true)
    }

    private func openPhotoPicker() {
        let photoLibrary = PHPhotoLibrary.shared()
        var configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
        configuration.filter = .images
        configuration.selectionLimit = 7

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        rootViewController.present(picker, animated: true)
    }

    private func openHorizonCalendar(_ model: SelectDateRangesVC.DataModel) {
        let selectDates = SelectDateRangesVC(dataModel: model)
        selectDates.coordinator = self
        selectDates.hidesBottomBarWhenPushed = true
        navigator.push(selectDates, animated: true)
    }

    private func openOpportunityDetailsMode(opportunityId: String) {
        let vc = OpportunityDetailsVC(opportunityId)
        vc.viewModel = OpportunitesDetailsViewModel()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        navigator.push(vc, animated: true)
    }

    private func deleteOpportunityAlert() {
        AlertHelper.showAlertWithTwoActions(rootViewController, title: "Delete this opportunity", leftButtonTitle: "Cancel", leftButtonStyle: .cancel, rightButtonTitle: "OK", leftAction: {}, rightAction: {
            let detailsVC = self.rootViewController.topViewController as? OpportunityDetailsVC
            detailsVC?.deleteOpportunity()
        })
    }

    /// This func is been called when we are returning to opportunities & we have to update `UI`
    private func updateOpportunities() {
        let previousVC = rootViewController.previousViewController as? OpportunitiesVC
        previousVC?.viewModel?.fetchModels()
        navigator.popViewController(animated: true)
    }

    private func hostSelectDays(dataModel: HostSelectDaysViewModel.DataModel) {
        let selectDaysVC = HostSelectDaysVC()
        selectDaysVC.viewModel = HostSelectDaysViewModel(dataModel: dataModel)
        selectDaysVC.coordinator = self
        navigator.push(selectDaysVC, animated: true)
    }

    private func additionalOfferings(_ optionals: OpportunityOptionals?) {
        let additionalOfferingsVC = HostAdditionalOfferingsVC()
        additionalOfferingsVC.viewModel = HostAdditionalOfferingsViewModel(dataModel: .init(optionals: optionals))
        additionalOfferingsVC.coordinator = self
        navigator.push(additionalOfferingsVC, animated: true)
    }
}

extension OpportunitiesCoordinator: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) // dismiss a picker
        let opportunityVC = rootViewController.topViewController as? CreateOpportunityVC

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
            opportunityVC?.viewModel?.images.append(contentsOf: images)
        }
    }
}
