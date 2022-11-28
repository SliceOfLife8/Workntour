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
            languages: traveler?.languages?.compactMap { $0.convertToCommonUI() } ?? []
        )
    }

    func getExperienceCellDataModel() -> ProfileExperienceCell.DataModel? {
        let experiences = [
            ProfileExperience(
                uuid: "CBDDA38B-996C-4CE7-9C5C-DD5FAF5F964A",
                experience: Experience(type: .COMPANY, organization: "Microsoft", position: "Software Engineer", startDate: "", endDate: "")
            ),
            ProfileExperience(
                uuid: "727FA0EF-8AA8-4BA5-8F6F-52BE790A7ECB",
                experience: Experience(type: .UNIVERSITY, organization: "Harvard", position: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled", startDate: "", endDate: "")
            ),
            ProfileExperience(
                uuid: "B4D561D4-1D64-4863-A475-E493E89A2BAE",
                experience: Experience(type: .COMPANY, organization: "Apple", position: "Product Designer", startDate: "", endDate: "")
            ),
            ProfileExperience(
                uuid: "473413EA-CDDA-4C09-A97D-F3427D63EA93",
                experience: Experience(type: .COMPANY, organization: "Samsung", position: "I am working on a quiz project and trying to convert an array of bools to an array of strings so that I can present the user with their answers. I have tried to enumerate the question array and pull out all the users answers and the correct answers and append them to a new array.", startDate: "", endDate: "")
            ),
            ProfileExperience(
                uuid: "00A71247-AAF7-4014-800B-3984E882C324",
                experience: Experience(type: .UNIVERSITY, organization: "TeamViewer", position: "We want to revamp the UI of our current tooltip and make it more engaging by adding a banner/animated banner along with the text.", startDate: "", endDate: "")
            )
        ]

        return .init(
            title: TravelerProfileSection.experience.value,
            description: "experience_placeholder".localized(),
            experiences: experiences.compactMap { $0.convertToCommonUI() }
        )
    }
}
