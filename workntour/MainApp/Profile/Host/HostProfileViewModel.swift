//
//  HostProfileViewModel.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 19/6/22.
//

import Combine
import Networking
import SharedKit
import UIKit

class HostProfileViewModel: BaseViewModel {
    /// Service
    private var service: ProfileService
    /// Inputs
    var isCompany: Bool = false
    @Published var companyHost: CompanyHostProfile?
    @Published var individualHost: IndividualHostProfile?

    var countries: Countries

    /// Outputs
    @Published var newImage: Data?
    @Published var profileUpdated: Bool = false

    // MARK: - Init
    init(service: ProfileService = DataManager.shared,
         isHostCompany: Bool) {
        self.service = service
        self.isCompany = isHostCompany
        self.companyHost = UserDataManager.shared.retrieve(CompanyHostProfile.self)
        self.individualHost = UserDataManager.shared.retrieve(IndividualHostProfile.self)
        self.countries = Countries()

        super.init()
    }

    func updateProfilePic(with imageData: Data?) {
        if isCompany {
            companyHost?.profileImage = imageData
        } else {
            individualHost?.image = imageData
        }
        newImage = imageData
    }

    func updateSelectedCountry(model: CountriesModel, index: Int) {
        countries.selectedCountryPrefix = model.regionCode
        countries.currentCountryFlag = model.flag
        countries.countrySelectedIndex = index
    }

    func updateProfile(postalAddress: String?,
                       mobileNum: String?,
                       fixedNumber: String?) {
        /// Update models + api request
        if isCompany {
            if let _postalAddress = postalAddress?.trimmingCharacters(in: .whitespaces) {
                companyHost?.postalAddress = _postalAddress
            }
            if mobileNum?.trimmingPhoneNumber().count == 10 {
                companyHost?.countryCode = countries.selectedCountryPrefix
                companyHost?.mobile = mobileNum?.getPhoneDetails().dropFirst().joined(separator: "")
            }
            if let _fixedNumber = fixedNumber?.trimmingCharacters(in: .whitespaces) {
                companyHost?.fixedNumber = _fixedNumber
            }

            updateCompanyHostProfile()
        } else {
            if let _postalAddress = postalAddress?.trimmingCharacters(in: .whitespaces) {
                companyHost?.postalAddress = _postalAddress
            }
            if mobileNum?.trimmingPhoneNumber().count == 10 {
                companyHost?.countryCode = countries.selectedCountryPrefix
                companyHost?.mobile = mobileNum?.getPhoneDetails().dropFirst().joined(separator: "")
            }
            if let _fixedNumber = fixedNumber?.trimmingCharacters(in: .whitespaces) {
                companyHost?.fixedNumber = _fixedNumber
            }

            updateIndividualHostProfile()
        }
    }

    private func updateCompanyHostProfile() {
        guard let companyModel = companyHost else {
            return
        }

        loaderVisibility = true
        service.updateCompanyHostProfile(model: companyModel)
            .map {
                if $0 != nil {
                    self.companyHost = $0
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

    private func updateIndividualHostProfile() {
        guard let individualModel = individualHost else {
            return
        }

        loaderVisibility = true
        service.updateIndividualHostProfile(model: individualModel)
            .map {
                if $0 != nil {
                    self.individualHost = $0
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
