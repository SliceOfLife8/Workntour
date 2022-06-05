//
//  RegistrationViewModel.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 22/5/22.
//

import Combine
import Networking
import SharedKit
import CommonUI

class RegistrationTravelerViewModel: BaseViewModel {
    /// Service
    weak private var service: AuthorizationService?

    // Inputs
    let input: PassthroughSubject<Void, Never>
    var cellsValues: [RegistrationModelType: String?] = Dictionary(uniqueKeysWithValues: [.name, .email, .password, .verifyPassword, .age, .phone, .nationality, .sex].map {($0, nil)})
    // Outputs
    @Published var data: [RegistrationModel] = []
    var countries: Countries
    var pullOfErrors: [RegistrationModelType: RegistrationError?] = [:]

    @Published private(set) var hole: Void
    @Published private(set) var errorMessage: String?

    init(service: AuthorizationService = DataManager.shared) {
        self.service = service
        self.countries = Countries()
        self.hole = ()
        self.input = PassthroughSubject<Void, Never>()

        super.init()
    }

    func fetchModels() {
        let countryPrefix = countries.selectedCountryPrefix ?? ""

        let models: [RegistrationModel] = [
            RegistrationModel(title: "Fullname", placeholder: "Enter your fullname", type: .name, error: pullOfErrors[.name].flatMap { $0 }?.description),
            RegistrationModel(title: "Email", placeholder: "Enter your email", type: .email, error: pullOfErrors[.email].flatMap { $0 }?.description),
            RegistrationModel(title: "Password", placeholder: "Enter your password", type: .password,
                              description: "Password should contain minimum of 8 characters total with at least 1 uppercase, 1 lowercase, 1 special character.",
                              error: pullOfErrors[.password].flatMap { $0 }?.description),
            RegistrationModel(title: "Confirm password", placeholder: "Confirm your password", type: .verifyPassword, error: pullOfErrors[.verifyPassword].flatMap { $0 }?.description),
            RegistrationModel(title: "Age", placeholder: "Select your Birthday Date", type: .age, error: pullOfErrors[.age].flatMap { $0 }?.description),
            RegistrationModel(title: "Phone Number", isRequired: false, optionalTextVisible: true, placeholder: "+\(countryPrefix) xxxxxxxxxx",
                              type: .phone, countryEmoji: countries.currentCountryFlag, prefixCode: countryPrefix, error: pullOfErrors[.phone].flatMap { $0 }?.description),
            RegistrationModel(title: "Nationality", isRequired: false, optionalTextVisible: true, placeholder: "Select your Nationality", type: .nationality),
            RegistrationModel(title: "Sex", isRequired: false, optionalTextVisible: true, placeholder: "I am", type: .sex)
        ]

        data = models
    }

    func updateSelectedCountry(model: CountriesModel, index: Int) {
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
                    pullOfErrors[.name] = .fullname
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
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                dateFormatter.timeZone = TimeZone(abbreviation: "GMT+00:00")
                guard let birthdayDate = dateFormatter.date(from: text),
                      let minimumRequiredDate = Calendar.current.date(byAdding: .year, value: -18, to: Date()) else {
                    break
                }

                if birthdayDate > minimumRequiredDate {
                    pullOfErrors[.age] = .age
                }
            case .phone:
                if text.count != 10 {
                    pullOfErrors[.phone] = .phoneNumber
                }
            default: break
            }
        }

        return pullOfErrors.count > 0
    }

    func registerTraveler() {
        /// Gather all properties
        let fullname = cellsValues[.name]?.flatMap { $0 } ?? ""
        let email = cellsValues[.email]?.flatMap { $0 } ?? ""
        let password = cellsValues[.password]?.flatMap { $0 } ?? ""
        let age = cellsValues[.age]?.flatMap { $0 } ?? ""
        let phoneNum = cellsValues[.phone]?.flatMap { $0 } ?? ""
        let nationality = cellsValues[.nationality]?.flatMap { $0 }
        let sex = cellsValues[.sex]?.flatMap { $0 }

        let traveler = Traveler(name: fullname, surname: fullname, role: UserRole.TRAVELER, email: email, password: password, memberID: "+30", countryCode: phoneNum, mobile: age, nationatility: nationality, sex: .MALE)

        input.compactMap { [weak self] _ in
            self?.service?.travelerRegistration(model: traveler)
        }
        .switchToLatest()
        .subscribe(on: RunLoop.main)
        .catch({ [weak self] error -> Just<Void> in
            print("Errorrr: ", error)
            self?.errorMessage = error.errorDescription
            return Just(Void())
        })
            .assign(to: &$hole)
    }

}
