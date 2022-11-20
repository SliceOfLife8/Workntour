//
//  TravelerProfileViewModel.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 17/6/22.
//

import Combine
import Networking
import SharedKit
import CommonUI
import UIKit

class TravelerProfileViewModel: BaseViewModel {
    /// Service
    private var service: ProfileService
    /// Inputs
    @Published var traveler: TravelerProfileDto?

    /// Outputs
    @Published var newImage: Data?
    @Published var profileUpdated: Bool = false
    var shouldShowAnimation: Bool = true

    // MARK: - Init
    init(service: ProfileService = DataManager.shared) {
        self.service = service
        self.traveler = UserDataManager.shared.retrieve(TravelerProfileDto.self)

        super.init()
    }

    func updateProfile(_ profileDto: TravelerProfileDto, data: Data? = nil) {
        loaderVisibility = true
        let updatedBody = TravelerUpdatedBody(updatedTravelerProfile: profileDto, profileImage: data)
        service.updateTravelerProfile(model: updatedBody)
            .map {
                if $0 != nil {
                    self.traveler = $0 // Update current user's model
                }

                return $0 != nil
            }
            .subscribe(on: RunLoop.main)
            .catch({ _ -> Just<Bool> in
                return Just(false)
            })
                .handleEvents(receiveCompletion: { _ in
                    self.loaderVisibility = false
                })
                    .assign(to: &$profileUpdated)
    }
}

// MARK: - DataModels
extension TravelerProfileViewModel {

    func getHeaderDataModel() -> ProfileHeaderView.DataModel? {
        guard let data = traveler else { return nil }
        let percents = data.percents

        return .init(
            mode: .traveler,
            profileUrl: nil,
            fullname: data.fullname,
            introText: "Don’t be shy! Workntour is all about getting to know new people, so please introduce yourself to us and to your potential hosts!",
            percent360: percents.percent360,
            percent100: percents.percent100,
            duration: percents.duration
        )
    }

    func getFooterDataModel() -> ProfileFooterView.DataModel? {
        guard let data = traveler else { return nil }

        return .init(
            dietaryTitle: "Special Dietary Requirements",
            dietarySelection: data.specialDietary?.rawValue ?? 0,
            licenseTitle: "Driver’s License",
            hasLicense: data.driverLicense ?? false
        )
    }

    func getSimpleCellDataModel(_ index: Int) -> ProfileSimpleCell.DataModel? {
        guard let data = traveler else { return nil }

        switch TravelerProfileSection(rawValue: index) {
        case .personalInfo:
            return .init(
                title: TravelerProfileSection.personalInfo.value,
                values: [],
                placeholder: "You can edit your personal info here."
            )
        case .description:
            return .init(
                title: TravelerProfileSection.description.value,
                values: [data.description],
                placeholder: "Describe how awesome you are, how you will be able to help your hosts and what you would like to learn!"
            )
        case .typeOfTraveler:
            return .init(
                title: TravelerProfileSection.typeOfTraveler.value,
                values: [data.type?.value],
                placeholder: "What type of traveler are you? Give us your input!"
            )
        case .interests:
            return .init(
                title: TravelerProfileSection.interests.value,
                values: data.interests?.compactMap { $0.value } ?? [],
                placeholder: "Add your interests so you can match with the perfect host."
            )
        case .skills:
            return .init(
                title: TravelerProfileSection.skills.value,
                values: data.skills?.compactMap { $0.value } ?? [],
                placeholder: "Add skills that you have that potentially help you match with a host."
            )
        default:
            assertionFailure("Check collectionView's sizeForItem func.")
            return nil
        }
    }

    func getLanguageCellDataModel() -> ProfileLanguageCell.DataModel? {
        // traveler?.languages?.compactMap { $0.convertToCommonUI() } ?? []
        let langs = [ProfileLanguage(language: .ITALIAN, proficiency: .BEGINNER),
                     ProfileLanguage(language: .SWEDISH, proficiency: .INTERMEDIATE)]
        return .init(
            title: TravelerProfileSection.languages.value,
            description: "Add your languages & your level.",
            languages: langs.compactMap { $0.convertToCommonUI() }
        )
    }

    func getExperienceCellDataModel() -> ProfileExperienceCell.DataModel? {
        let experience = [
            Experience(type: .COMPANY, organization: "Microsoft", position: "Software Engineer", startDate: "", endDate: ""),
            Experience(type: .UNIVERSITY, organization: "Harvard", position: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled", startDate: "", endDate: ""),
            Experience(type: .COMPANY, organization: "Apple", position: "Product Designer", startDate: "", endDate: "")
            ]
        let dict: [ProfileExperienceCell.DataModel.Mode: [ProfileExperienceCell.DataModel.ExperienceUI]] = [
            .professional: experience.compactMap { $0.getProfessionalExperiences() },
            .educational: experience.compactMap { $0.getEducationalExperiences() }
        ]
        return .init(
            title: TravelerProfileSection.experience.value,
            description: "Add your Experience",
            experiences: dict
        )
    }
}
