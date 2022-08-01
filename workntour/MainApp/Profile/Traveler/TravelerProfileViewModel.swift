//
//  TravelerProfileViewModel.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 17/6/22.
//

import Combine
import Networking
import SharedKit

class TravelerProfileViewModel: BaseViewModel {
    /// Service
    private var service: ProfileService
    /// Inputs
    @Published var traveler: TravelerProfile?

    var countries: Countries

    /// Outputs
    @Published var newImage: Data?
    @Published var profileUpdated: Bool = false

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
