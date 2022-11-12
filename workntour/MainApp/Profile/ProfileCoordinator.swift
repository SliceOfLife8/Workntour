//
//  ProfileCoordinator.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 17/6/22.
//

import UIKit
import SharedKit
import PhotosUI

/** A Coordinator which is responsible about profile section for `Hosts` & `Travelers` . */

enum ProfileStep: Step {
    case state(_ default: DefaultStep)
    case openGalleryPicker
    case selectInterests(preselectedInterests: [LearningOpportunities])
    case selectSkills(preselectedSkills: [TypeOfHelp])
}

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
            let hostVC = HostProfileVC()
            hostVC.viewModel = HostProfileViewModel(isHostCompany: userRole == .COMPANY_HOST)
            hostVC.coordinator = self

            navigator.push(hostVC, animated: true)
        }
    }

    func navigate(to step: ProfileStep) {
        switch step {
        case .state(.back):
            navigator.popViewController(animated: true)
        case .state(.showAlert(let title, let subtitle)):
            AlertHelper.showDefaultAlert(rootViewController,
                                         title: title,
                                         message: subtitle)
        case .openGalleryPicker:
            openPhotoPicker()
        case .selectInterests(let learningOpportunities):
            selectInterests(learningOpportunities)
        case .selectSkills(let skills):
            selectSkills(skills)
        }
    }

    private func openPhotoPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        rootViewController.present(picker, animated: true)
    }

    private func selectInterests(_ preselectedInterests: [LearningOpportunities]) {
        let attributes = LearningOpportunities.allCases.map {
            ProfileSelectAttributesViewModel.ProfileAttribute(title: $0.value,
                                                              isSelected: preselectedInterests.contains($0))
        }

        let data = ProfileSelectAttributesViewModel.DataModel(
            navigationBarTitle: "ur_interests".localized(),
            mode: .interests,
            headerTitle: "interests".localized(),
            description: "interests_description".localized(),
            minItemsToBeSelected: 3,
            attributes: attributes
        )
        let selectAttributesVC = ProfileSelectAttributesVC()
        selectAttributesVC.viewModel = ProfileSelectAttributesViewModel(data: data)
        selectAttributesVC.coordinator = self

        navigator.push(selectAttributesVC, animated: true)
    }

    private func selectSkills(_ preselectedSkills: [TypeOfHelp]) {
        let attributes = TypeOfHelp.allCases.map {
            ProfileSelectAttributesViewModel.ProfileAttribute(title: $0.value,
                                                              isSelected: preselectedSkills.contains($0))
        }

        let data = ProfileSelectAttributesViewModel.DataModel(
            navigationBarTitle: "ur_skills".localized(),
            mode: .skills,
            headerTitle: "skills".localized(),
            description: "skills_description".localized(),
            minItemsToBeSelected: 3,
            attributes: attributes
        )
        let selectAttributesVC = ProfileSelectAttributesVC()
        selectAttributesVC.viewModel = ProfileSelectAttributesViewModel(data: data)
        selectAttributesVC.coordinator = self

        navigator.push(selectAttributesVC, animated: true)
    }

}

// MARK: - PhotoUI Picker
extension ProfileCoordinator: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) // dismiss a picker

        let imageItem = results
            .map { $0.itemProvider }
            .filter { $0.canLoadObject(ofClass: UIImage.self) }
            .first

        imageItem?.loadObject(ofClass: UIImage.self) { image, _ in
            if let image = image as? UIImage {
                DispatchQueue.main.async {
                    if let hostProfileVC = self.rootViewController.topViewController as? HostProfileVC {
                        hostProfileVC.viewModel?.updateProfilePic(with: image.jpeg(.medium))
                    } else if let travelerProfileVC = self.rootViewController.topViewController as? TravelerProfileVC {
                        travelerProfileVC.viewModel?.newImage = image.jpeg(.medium)
                    }
                }
            }
        }
    }
}
