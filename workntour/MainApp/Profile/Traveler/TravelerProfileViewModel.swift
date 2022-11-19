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
    @Published var traveler: TravelerProfile?

    var countries: Countries

    /// Outputs
    @Published var newImage: Data?
    @Published var profileUpdated: Bool = false
    var shouldShowAnimation: Bool = true

    // MARK: - Init
    init(service: ProfileService = DataManager.shared) {
        self.service = service
        self.traveler = UserDataManager.shared.retrieve(TravelerProfile.self)
        self.countries = Countries()

        super.init()
    }

    func updateSelectedCountry(model: CountriesModel, index: Int) {
        countries.selectedCountryPrefix = model.regionCode
        countries.currentCountryFlag = model.flag
        countries.countrySelectedIndex = index
    }

    /// Update models + api request
    func updateProfile(age: String?,
                       postalAddress: String?,
                       mobileNum: String?) {

        if let _age = age?.trimmingCharacters(in: .whitespaces) {
            traveler?.birthday = _age.changeDateFormat()
        }

        if let _postalAddress = postalAddress?.trimmingCharacters(in: .whitespaces) {
            traveler?.postalAddress = _postalAddress
        }
        if mobileNum?.trimmingPhoneNumber().count == 10 {
            traveler?.countryCode = countries.selectedCountryPrefix
            traveler?.mobile = mobileNum?.getPhoneDetails().dropFirst().joined(separator: "")
        }

        updateTravelerProfile()
    }

    func updateProfile(_ profileDto: TravelerProfile) {
        loaderVisibility = true
        service.updateTravelerProfile(model: profileDto)
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

    private func updateTravelerProfile() {
        guard let travelerModel = traveler else {
            return
        }

        loaderVisibility = true
        service.updateTravelerProfile(model: travelerModel)
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
        // guard let data = traveler else { return nil }

        return .init(
            dietaryTitle: "Special Dietary Requirements",
            dietarySelection: 0,
            licenseTitle: "Driver’s License",
            hasLicense: false
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
                values: [],
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
                values: [],
                placeholder: "Add your interests so you can match with the perfect host."
            )
        case .skills:
            return .init(
                title: TravelerProfileSection.skills.value,
                values: [],
                placeholder: "Add skills that you have that potentially help you match with a host."
            )
        default:
            return nil
        }
    }

    func getLanguageCellDataModel() -> ProfileSimpleCell.DataModel? {
        return .init(
            title: TravelerProfileSection.languages.value,
            values: [],
            placeholder: "Add your languages & your level."
        )
    }
}
