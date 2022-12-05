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
        guard let countryCode = data.mode.getCountryCode,
              !countryCode.isEmpty
        else {
            return countries.selectedCountryPrefix ?? "30"
        }

        return countryCode
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
        let phoneDetails = mobileNum?.getPhoneDetails()
        data.mode.adjust(
            name: name,
            surname: surname,
            address: address,
            city: city,
            postalCode: postalCode,
            country: country,
            mobileNum: phoneDetails?.count == 1 ? phoneDetails?.joined() : phoneDetails?.dropFirst().joined(),
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
                case .company(let profile):
                    let newProfile = CompanyHostProfileDto(
                        memberID: profile.memberID,
                        role: profile.role,
                        name: name,
                        email: profile.email,
                        city: city,
                        address: address,
                        country: country,
                        postalAddress: postalCode,
                        countryCode: profile.countryCode,
                        mobile: mobileNum,
                        fixedNumber: fixedNum,
                        vat: vatNum
                    )
                    self = .company(newProfile)
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
                    self = .company(profile)
                case .individual(var profile):
                    profile.countryCode = code
                    self = .individual(profile)
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
