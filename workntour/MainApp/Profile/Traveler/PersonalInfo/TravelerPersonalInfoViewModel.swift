//
//  TravelerPersonalInfoViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 16/11/22.
//

import SharedKit

class TravelerPersonalInfoViewModel: BaseViewModel {

    // MARK: - Properties

    var data: DataModel
    var countries: Countries

    var countryPrefix: String {
        return data.profile.countryCode ?? (countries.selectedCountryPrefix ?? "30")
    }

    var countryFlag: String? {
        return Countries.countryPrefixes.key(from: countryPrefix)?.countryFlag()
    }

    /// Outputs
    @Published var updateProfileDto: TravelerProfileDto?

    // MARK: - Init

    required init(data: DataModel) {
        self.data = data
        self.countries = Countries()
    }

    // MARK: - Methods

    func updateSelectedCountry(model: CountriesModel, index: Int) {
        data.profile.countryCode = model.regionCode
        countries.selectedCountryPrefix = model.regionCode
        countries.currentCountryFlag = model.flag
        countries.countrySelectedIndex = index
    }

    func updatePersonalInfo(
        name: String,
        surname: String,
        age: String?,
        email: String,
        address: String?,
        city: String?,
        postalCode: String?,
        country: String?,
        mobileNum: String?
    ) {
        data.profile.name = name
        data.profile.surname = surname
        data.profile.birthday = age?.changeDateFormat()
        data.profile.email = email
        data.profile.postalAddress = postalCode
        data.profile.mobile = mobileNum?.getPhoneDetails().dropFirst().joined(separator: "")
        // Pending address, city, country
        self.updateProfileDto = data.profile
    }
}

// MARK: - TravelerPersonalInfoViewModel.DataModel
extension TravelerPersonalInfoViewModel {

    class DataModel {

        // MARK: - Properties

        var profile: TravelerProfileDto

        // MARK: - Constructors/Destructors
        init(profile: TravelerProfileDto) {
            self.profile = profile
        }
    }
}
