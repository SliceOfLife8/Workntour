//
//  RegistrationHostViewModel.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 8/6/22.
//

import Combine
import Networking
import SharedKit
import CommonUI

class RegistrationHostViewModel: BaseViewModel {
    /// Service
    private var service: AuthorizationService
    private(set) var userRole: UserRole
    var cellsValues: [RegistrationModelType: String?] = [:]

    /// Inputs
    @Published var data: [RegistrationModel] = []
    /// Outputs
    @Published var individualSelected: Bool = true
    @Published var loaderVisibility: Bool = false
    @Published var signUpCompleted: String?
    @Published var errorMessage: String?

    var countries: Countries
    var pullOfErrors: [RegistrationModelType: RegistrationError?] = [:]

    init(service: AuthorizationService = DataManager.shared, userRole: UserRole = .INDIVIDUAL_HOST) {
        self.service = service
        self.userRole = userRole
        self.countries = Countries()

        super.init()
        cellValuesInit()
    }

    func cellValuesInit() {
        cellsValues = [
            .name: nil,
            .surname: nil,
            .password: nil,
            .verifyPassword: nil,
            .age: nil,
            .phone: nil,
            .vatNumber: nil,
            .apd: nil
        ]
    }

    /// Fetch models function is responsible to create a common array of models shared among `Individual` & `Host`
    func fetchModels(_ role: UserRole) {
        userRole = role
        pullOfErrors.removeAll()
        cellValuesInit() // Reset cell values

        var models: [RegistrationModel] = [
            RegistrationModel(title: "Name",
                              placeholder: "Enter your name",
                              type: .name),
            RegistrationModel(title: "Surname",
                              placeholder: "Enter your surname",
                              type: .surname),
            RegistrationModel(title: "Email",
                              placeholder: "Enter your email",
                              type: .email),
            RegistrationModel(title: "Password",
                              placeholder: "Enter your password",
                              type: .password,
                              description: "Password should contain minimum of 8 characters total with at least 1 uppercase, 1 lowercase, 1 special character."),
            RegistrationModel(title: "Confirm password",
                              placeholder: "Confirm your password",
                              type: .verifyPassword)
        ]

        if userRole == .INDIVIDUAL_HOST {
            models.append(contentsOf: individualHostExtraModels())
        } else {
            models.remove(at: [0, 1]) // Drop first two items
            models.insert(RegistrationModel(title: "Company Name",
                                            placeholder: "Enter your company name",
                                            type: .name), at: 0)
            models.append(contentsOf: companyHostExtraModels())
        }

        data = models
    }

    /// Extra models about host category -> `Individual`
    /// - returns: The updated-final array of models.
    private func individualHostExtraModels() -> [RegistrationModel] {
        let countryPrefix = countries.selectedCountryPrefix ?? ""

        return [
            RegistrationModel(title: "Age",
                              placeholder: "Select your Birthday Date",
                              type: .age),
            RegistrationModel(title: "Phone Number",
                              isRequired: false,
                              optionalTextVisible: true,
                              placeholder: "+\(countryPrefix) xxxxxxxxxx",
                              type: .phone,
                              countryEmoji: countries.currentCountryFlag,
                              prefixCode: countryPrefix)
        ]
    }

    /// Extra models about host category -> `Company`
    /// - returns: The updated-final array of models.
    private func companyHostExtraModels() -> [RegistrationModel] {
        return [
            RegistrationModel(title: "Company VAT Number",
                              placeholder: "Enter your company ID",
                              type: .vatNumber),
            RegistrationModel(title: "Authorized Person Document",
                              isRequired: false,
                              optionalTextVisible: true,
                              placeholder: "",
                              type: .apd)
        ]
    }

    func updateSelectedCountry(model: CountriesModel, index: Int) {
        cellsValues[.phone] = nil
        countries.selectedCountryPrefix = model.regionCode
        countries.currentCountryFlag = model.flag
        countries.countrySelectedIndex = index
    }

    /// Verify all required fields about -> `Individual`
    /// - returns: If user inputs contain errors.
    // swiftlint:disable cyclomatic_complexity
    func verifyRequiredFieldsAboutIndividualHost() -> Bool {
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

    /// Verify all required fields about -> `Company`
    /// - returns: If user inputs contain errors.
    func verifyRequiredFieldsAboutCompanyHost() -> Bool {
        pullOfErrors.removeAll()

        for (key, value) in cellsValues {
            guard let text = value?.trimmingCharacters(in: .whitespaces) else {
                continue
            }

            switch key {
            case .name:
                if text.isEmpty {
                    pullOfErrors[.name] = .name
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
            case .vatNumber:
                if text.count != 9 {
                    pullOfErrors[.vatNumber] = .vat
                }
            default: break
            }
        }

        return pullOfErrors.count > 0
    }

    func registerIndividualHost() {
        /// Gather all properties
        let name = cellsValues[.name]?.flatMap { $0 } ?? ""
        let surname = cellsValues[.surname]?.flatMap { $0 } ?? ""
        let email = cellsValues[.email]?.flatMap { $0 } ?? ""
        let password = cellsValues[.password]?.flatMap { $0 } ?? ""
        let phoneNumDetails = cellsValues[.phone]?.flatMap { $0 }?.getPhoneDetails()
        let countryCode = phoneNumDetails?.first
        let mobile = phoneNumDetails?.dropFirst().joined(separator: "")
        let age = cellsValues[.age]?.flatMap { $0 }?.changeDateFormat()

        let model = IndividualHost(name: name, surname: surname, role: .INDIVIDUAL_HOST, email: email, password: password, countryCode: countryCode, mobile: mobile, birthday: age)

        loaderVisibility = true
        service
            .individualHostRegistration(model: model)
            .subscribe(on: RunLoop.main)
            .catch({ [weak self] error -> Just<String?> in
                if case .invalidServerResponseWithStatusCode(let code) = error, code == 409 {
                    self?.errorMessage = "This email address is already being used!"
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

    func registerCompanyHost() {
        /// Gather all properties
        let companyName = cellsValues[.name]?.flatMap { $0 } ?? ""
        let email = cellsValues[.email]?.flatMap { $0 } ?? ""
        let password = cellsValues[.password]?.flatMap { $0 } ?? ""
        let vatNum = cellsValues[.vatNumber]?.flatMap { $0 }

        let model = CompanyHost(name: companyName, role: .COMPANY_HOST, email: email, password: password, id: vatNum)

        loaderVisibility = true
        service
            .companyHostRegistration(model: model)
            .subscribe(on: RunLoop.main)
            .catch({ [weak self] error -> Just<String?> in
                self?.errorMessage = error.errorDescription
                return Just(nil)
            })
                .handleEvents(receiveCompletion: { _ in
                    self.loaderVisibility = false
                })
                    .assign(to: &$signUpCompleted)
    }

}
