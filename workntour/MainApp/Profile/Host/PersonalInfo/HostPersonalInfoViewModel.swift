//
//  HostPersonalInfoViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 30/11/22.
//

import SharedKit

class HostPersonalInfoViewModel: BaseViewModel {

    // MARK: - Properties

    var data: DataModel
    var countries: Countries

    var countryPrefix: String {
        return data.mode.getCountryCode ?? (countries.selectedCountryPrefix ?? "30")
    }

    var countryFlag: String? {
        return Countries.countryPrefixes.key(from: countryPrefix)?.countryFlag()
    }

    // MARK: - Init

    required init(data: DataModel) {
        self.data = data
        self.countries = Countries()
    }

    // MARK: - Methods

    func updateSelectedCountry(model: CountriesModel, index: Int) {
        data.mode.changeCountryCode(code: model.regionCode)
        countries.selectedCountryPrefix = model.regionCode
        countries.currentCountryFlag = model.flag
        countries.countrySelectedIndex = index
    }

    func updatePersonalInfo(
        name: String,
        surname: String,
        address: String?,
        city: String?,
        postalCode: String?,
        country: String?,
        mobileNum: String?,
        fixedNum: String?,
        vatNum: String?
    ) {
        data.mode.adjust(
            name: name,
            surname: surname,
            address: address,
            city: city,
            postalCode: postalCode,
            country: country,
            mobileNum: mobileNum,
            fixedNum: fixedNum,
            vatNum: vatNum
        )
    }
    
}

// MARK: - HostPersonalInfoViewModel.DataModel
extension HostPersonalInfoViewModel {

    class DataModel {

        enum Mode {
            case company(CompanyHostProfileDto)
            case individual(IndividualHostProfileDto)
            case none

            mutating func adjust(
                name: String,
                surname: String,
                address: String?,
                city: String?,
                postalCode: String?,
                country: String?,
                mobileNum: String?,
                fixedNum: String?,
                vatNum: String?
            ) {
                switch self {
                case .company(var profile):
                    profile.name = name
                    profile.postalAddress = postalCode
                case .individual(var profile):
                    profile.postalAddress = postalCode
                case .none:
                    break
                }
            }

            mutating func changeCountryCode(code: String) {
                switch self {
                case .company(var profile):
                    profile.countryCode = code
                case .individual(var profile):
                    profile.countryCode = code
                case .none:
                    break
                }
            }

            var getCountryCode: String? {
                switch self {
                case .company(let profile):
                    return profile.countryCode
                case .individual(let profile):
                    return profile.countryCode
                case .none:
                    return nil
                }
            }
        }

        // MARK: - Properties

        var mode: Mode

        // MARK: - Constructors/Destructors

        init(mode: Mode) {
            self.mode = mode
        }
    }
}
