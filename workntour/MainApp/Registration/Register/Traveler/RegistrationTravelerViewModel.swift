//
//  RegistrationTravelerViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 22/5/22.
//

import Combine
import Networking
import SharedKit
import CommonUI

class RegistrationTravelerViewModel: BaseViewModel {
    /// Service
    private var service: AuthorizationService

    /// Inputs
    var data: [RegistrationModel] = []
    var cellsValues: [GradientTextFieldType: String?] = Dictionary(uniqueKeysWithValues: [.name, .surname, .email, .password, .verifyPassword, .age, .phone, .nationality, .sex].map {($0, nil)})
    /// Outputs
    @Published var signUpCompleted: String?
    @Published var errorMessage: String?

    var countries: Countries
    var pullOfErrors: [GradientTextFieldType: RegistrationError?] = [:]

    init(service: AuthorizationService = DataManager.shared) {
        self.service = service
        self.countries = Countries()

        super.init()
    }

    func fetchModels() {
        let countryPrefix = countries.selectedCountryPrefix ?? ""

        let models: [RegistrationModel] = [
            RegistrationModel(title: "name".localized(),
                              placeholder: "name_placeholder".localized(),
                              type: .name,
                              error: pullOfErrors[.name].flatMap { $0 }?.description),
            RegistrationModel(title: "surname".localized(),
                              placeholder: "surname_placeholder".localized(),
                              type: .surname,
                              error: pullOfErrors[.surname].flatMap { $0 }?.description),
            RegistrationModel(title: "email".localized(),
                              placeholder: "email_placeholder".localized(),
                              type: .email,
                              error: pullOfErrors[.email].flatMap { $0 }?.description),
            RegistrationModel(title: "password".localized(),
                              placeholder: "password_placeholder".localized(),
                              type: .password,
                              description: "password_description".localized(),
                              error: pullOfErrors[.password].flatMap { $0 }?.description),
            RegistrationModel(title: "confirm_password".localized(),
                              placeholder: "confirm_password_placeholder".localized(),
                              type: .verifyPassword,
                              error: pullOfErrors[.verifyPassword].flatMap { $0 }?.description),
            RegistrationModel(title: "age".localized(),
                              placeholder: "age_placeholder".localized(),
                              type: .age,
                              error: pullOfErrors[.age].flatMap { $0 }?.description),
            RegistrationModel(title: "phone_num".localized(),
                              isRequired: false,
                              optionalTextVisible: true,
                              placeholder: "+\(countryPrefix) xxxxxxxxxx",
                              type: .phone,
                              countryEmoji: countries.currentCountryFlag,
                              prefixCode: countryPrefix,
                              error: pullOfErrors[.phone].flatMap { $0 }?.description),
            RegistrationModel(title: "nationality".localized(),
                              isRequired: false,
                              optionalTextVisible: true,
                              placeholder: "nationality_placeholder".localized(),
                              type: .nationality),
            RegistrationModel(title: "sex".localized(),
                              isRequired: false,
                              optionalTextVisible: true,
                              placeholder: "sex_placeholder".localized(),
                              type: .sex)
        ]

        data = models
    }

    func updateSelectedCountry(model: CountriesModel, index: Int) {
        cellsValues[.phone] = nil
        countries.selectedCountryPrefix = model.regionCode
        countries.currentCountryFlag = model.flag
        countries.countrySelectedIndex = index
    }

    /// Gather all textFields values and check about verification!
    /// Returns true when at least an error was occured.
    // swiftlint:disable cyclomatic_complexity
    func verifyRequiredFields() -> Bool {
        pullOfErrors.removeAll()

        for (key, value) in cellsValues {
            let text = value?.trimmingCharacters(in: .whitespaces) ?? ""

            switch key {
            case .name:
                if text.isEmpty {
                    pullOfErrors[.name] = .name
                }
            case .surname:
                if text.isEmpty {
                    pullOfErrors[.surname] = .surname
                }
            case .email:
                if text.isEmailValid() == false {
                    pullOfErrors[.email] = .email
                }
            case .password:
                if text.isPasswordValid() == false {
                    pullOfErrors[.password] = .password
                }
            case .verifyPassword:
                if text != cellsValues[.password] {
                    pullOfErrors[.verifyPassword] = .confirmPassword
                }
            case .age:
                if !text.userAgeEligibility() {
                    pullOfErrors[.age] = .age
                }
            case .phone:
                let digits = text.trimmingPhoneNumber().count
                if digits > 0 && digits != 10 {
                    pullOfErrors[.phone] = .phoneNumber
                }
            default: break
            }
        }

        return pullOfErrors.count > 0
    }

    func registerTraveler() {
        /// Gather all properties
        let name = cellsValues[.name]?.flatMap { $0 } ?? ""
        let surname = cellsValues[.surname]?.flatMap { $0 } ?? ""
        let email = cellsValues[.email]?.flatMap { $0 } ?? ""
        let password = cellsValues[.password]?.flatMap { $0 } ?? ""
        let phoneNumDetails = cellsValues[.phone]?.flatMap { $0 }?.getPhoneDetails()
        let countryCode = phoneNumDetails?.first
        let mobile = phoneNumDetails?.dropFirst().joined(separator: "")
        let age = cellsValues[.age]?.flatMap { $0 }?.changeDateFormat()
        let nationality = cellsValues[.nationality]?.flatMap { $0 }
        let sex = UserSex(rawValue: cellsValues[.sex]?.flatMap { $0 } ?? "")

        let traveler = Traveler(name: name, surname: surname, role: .TRAVELER, email: email, password: password, countryCode: countryCode, mobile: mobile, nationatility: nationality, sex: sex, birthday: age)

        loaderVisibility = true
        service
            .travelerRegistration(model: traveler)
            .subscribe(on: RunLoop.main)
            .catch({ [weak self] error -> Just<String?> in
                if case .invalidServerResponseWithStatusCode(let code) = error, code == 409 {
                    self?.errorMessage = "email_already_used".localized()
                } else {
                    self?.errorMessage = error.errorDescription
                }

                return Just(nil)
            })
                .handleEvents(receiveCompletion: { _ in
                    self.loaderVisibility = false
                })
                    .assign(to: &$signUpCompleted)
    }

}
