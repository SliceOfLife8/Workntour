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
    case updateTravelerProfile(_ profile: TravelerProfileDto)
    case travelerEditPersonalInfo
    case selectInterests(preselectedInterests: [LearningOpportunities])
    case selectSkills(preselectedSkills: [TypeOfHelp])
    case openExperience(_ experience: Experience?)
    case travelerAddSummary(_ summary: String?)
    case addLanguage(existingLanguages: [Language])
    case editLanguage(_ language: ProfileLanguage)
    case travelerSelectType(_ type: TravelerType?)
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
        case .updateTravelerProfile(let profileDto):
            let travelerProfileVC = rootViewController.viewControllers.first as? TravelerProfileVC
            travelerProfileVC?.viewModel?.updateProfile(profileDto)

            navigator.popViewController(animated: true)
        case .openGalleryPicker:
            openPhotoPicker()
        case .travelerEditPersonalInfo:
            guard let profileDto = UserDataManager.shared.retrieve(TravelerProfileDto.self) else {
                assertionFailure("It's impossible to reach here! So, you fucked up!")
                return
            }

            let editInfoVC = TravelerPersonalInfoVC()
            editInfoVC.viewModel = TravelerPersonalInfoViewModel(data: .init(profile: profileDto))
            editInfoVC.coordinator = self

            navigator.push(editInfoVC, animated: true)
        case .selectInterests(let learningOpportunities):
            selectInterests(learningOpportunities)
        case .selectSkills(let skills):
            selectSkills(skills)
        case .openExperience(let experience):
            let experienceVC = ProfileExperienceVC()
            experienceVC.viewModel = ProfileExperienceViewModel(data: .init(experience: experience))
            experienceVC.coordinator = self

            navigator.push(experienceVC, animated: true)
        case .travelerAddSummary(let summary):
            addSummary(summary)
        case .addLanguage(let languages):
            let viewModel = LanguagePickerViewModel(data: .init(exludeLanguages: languages))
            let languagePickerVC = LanguagePickerVC()
            languagePickerVC.viewModel = viewModel
            languagePickerVC.coordinator = self

            navigator.push(languagePickerVC, animated: true)
        case .editLanguage(let language):
            let viewModel = LanguagePickerViewModel(data: .init(exludeLanguages: [], editLanguage: language))
            let languagePickerVC = LanguagePickerVC()
            languagePickerVC.viewModel = viewModel
            languagePickerVC.coordinator = self

            navigator.push(languagePickerVC, animated: true)
        case .travelerSelectType(let type):
            selectTravelerType(type)
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

    private func addSummary(_ summary: String?) {
        let data = ProfileAddSummaryViewModel.DataModel(
            navigationBarTitle: "describe_header".localized(),
            description: summary,
            placeholder: "describe_placeholder".localized(),
            charsLimit: 200
        )

        let addSummaryVC = ProfileAddSummaryVC()
        addSummaryVC.viewModel =  ProfileAddSummaryViewModel(data: data)
        addSummaryVC.coordinator = self

        navigator.push(addSummaryVC, animated: true)
    }

    private func selectTravelerType(_ type: TravelerType?) {
        let attributes = TravelerType.allCases.map {
            ProfileSelectAttributesViewModel.ProfileAttribute(title: $0.value,
                                                              isSelected: type == $0)
        }

        let data = ProfileSelectAttributesViewModel.DataModel(
            navigationBarTitle: "type_of_traveler_header".localized(),
            mode: .travelerType,
            headerTitle: "type_of_traveler_title".localized(),
            description: "type_of_traveler_description".localized(),
            minItemsToBeSelected: 1,
            attributes: attributes,
            allowMultipleSelection: false
        )
        let selectAttributesVC = ProfileSelectAttributesVC()
        selectAttributesVC.viewModel = ProfileSelectAttributesViewModel(data: data)
        selectAttributesVC.coordinator = self

        navigator.push(selectAttributesVC, animated: true)
    }


    /// This func is responsible for modify ProfileLanguage objects
    /// - Parameters:
    ///   - mode: What operation we would like to do
    ///   - language: Current language object
    ///   - profileDto: Traveler's profileDto
    func modifyLanguage(
        mode: LanguageMode,
        language: ProfileLanguage,
        profileDto: TravelerProfileDto
    ) {
        var updatedProfileDto = profileDto
        switch mode {
        case .add:
            updatedProfileDto.languages?.append(language)
        case .edit:
            if let index = updatedProfileDto.languages?.firstIndex(where: { $0.language == language.language }) {
                updatedProfileDto.languages?[index] = language
            }
        case .delete:
            updatedProfileDto.languages = updatedProfileDto.languages?.filter { $0.language != language.language }
        }

        navigate(to: .updateTravelerProfile(updatedProfileDto))
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
