//
//  TravelerProfileViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 17/6/22.
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
    var traveler: TravelerProfileDto?

    /// Outputs
    @Published var newImage: Media?
    @Published var profileUpdated: Bool = false
    @Published var getRefreshedProfile: Bool = false
    var shouldShowAnimation: Bool = true

    // MARK: - Init
    init(service: ProfileService = DataManager.shared) {
        self.service = service
        self.traveler = UserDataManager.shared.retrieve(TravelerProfileDto.self)

        super.init()
    }

    func updateProfile(_ incomingProfileDto: TravelerProfileDto? = nil, withMedia media: Media? = nil) {
        guard let traveler else { return }
        let profileDto = incomingProfileDto ?? traveler
        
        loaderVisibility = true
        let updatedBody = TravelerUpdatedBody(updatedTravelerProfile: profileDto, media: media)

        MediaContext.updateTraveler(body: updatedBody).dataRequest(
            objectType: GenericResponse<TravelerProfileDto>.self,
            completion: { (result: Result) in
                switch result {
                case .success(let profile):
                    DispatchQueue.main.async {
                        self.profileUpdated = true
                        self.loaderVisibility = false
                    }
                    self.traveler = profile.data
                    UserDataManager.shared.save(
                        profile.data,
                        memberId: profile.data?.memberID,
                        role: profile.data?.role
                    )
                case .failure:
                    DispatchQueue.main.async {
                        self.profileUpdated = false
                        self.loaderVisibility = false
                    }
                }
            })
    }

    func retrieveProfile() {
        guard let memberId = UserDataManager.shared.memberId else { return }
        
        service.getTravelerProfile(memberId: memberId)
            .subscribe(on: RunLoop.main)
            .catch({ _ -> Just<Bool> in
                return Just(false)
            })
                .handleEvents(receiveCompletion: { _ in
                    self.loaderVisibility = false
                })
                    .assign(to: &$getRefreshedProfile)
    }
}

// MARK: - DataModels
extension TravelerProfileViewModel {

    func getHeaderDataModel() -> ProfileHeaderView.DataModel? {
        guard let data = traveler else { return nil }
        let percents = data.percents

        return .init(
            mode: .traveler,
            profileUrl: data.getProfileImage(),
            fullname: data.fullname,
            introText: "traveler_intro".localized(),
            percent360: percents.percent360,
            percent100: percents.percent100,
            duration: percents.duration
        )
    }

    func getFooterDataModel() -> ProfileFooterView.DataModel? {
        guard let data = traveler else { return nil }

        return .init(
            dietaryTitle: "dietary_title".localized(),
            dietarySelection: data.specialDietary?.intValue ?? 0,
            licenseTitle: "license_title".localized(),
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
                placeholder: "personal_info_placeholder".localized()
            )
        case .description:
            return .init(
                title: TravelerProfileSection.description.value,
                values: [data.description],
                placeholder: "description_placeholder".localized()
            )
        case .typeOfTraveler:
            return .init(
                title: TravelerProfileSection.typeOfTraveler.value,
                values: [data.type?.value],
                placeholder: "type_of_traveler_description".localized()
            )
        case .interests:
            return .init(
                title: TravelerProfileSection.interests.value,
                values: data.interests?.compactMap { $0.value } ?? [],
                placeholder: "interests_placeholder".localized()
            )
        case .skills:
            return .init(
                title: TravelerProfileSection.skills.value,
                values: data.skills?.compactMap { $0.value } ?? [],
                placeholder: "skills_placeholder".localized()
            )
        default:
            assertionFailure("Check collectionView's sizeForItem func.")
            return nil
        }
    }

    func getLanguageCellDataModel() -> ProfileLanguageCell.DataModel? {
        return .init(
            title: TravelerProfileSection.languages.value,
            description: "languages_placeholder".localized(),
            languages: traveler?.language?.compactMap { $0.convertToCommonUI() } ?? []
        )
    }

    func getExperienceCellDataModel() -> ProfileExperienceCell.DataModel? {
        return .init(
            title: TravelerProfileSection.experience.value,
            description: "experience_placeholder".localized(),
            experiences: traveler?.experience?.compactMap { $0.convertToCommonUI() } ?? []
        )
    }
}
