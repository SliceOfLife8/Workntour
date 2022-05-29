//
//  RegistrationViewModel.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 22/5/22.
//

import Foundation
import Combine
import Networking
import SharedKit

class RegistrationViewModel: BaseViewModel {
    /// Service
    weak private var service: AuthorizationService?
    /// Locale properties
    private var localIdentifier = Locale.current.collatorIdentifier ?? Locale.current.identifier
    private var regionCode = Locale.current.regionCode ?? "GR"

    // Inputs
    let input: PassthroughSubject<Void, Never>
    // Outputs
    var data = PassthroughSubject<[RegistrationModel], Never>()
    var countries: [String: String]
    var currentCountryFlag: String?

    @Published private(set) var hole: Void
    @Published private(set) var errorMessage: String?

    init(service: AuthorizationService = DataManager.shared) {
        self.service = service
        self.countries = [:]
        self.hole = ()
        self.input = PassthroughSubject<Void, Never>()

        super.init()
    }

    func fetchModels() {
        let models: [RegistrationModel] = [
            RegistrationModel(title: "Fullname", placeholder: "Enter your fullname"),
            RegistrationModel(title: "Email", placeholder: "Enter your email", textFieldKeyboardType: .emailAddress),
            RegistrationModel(title: "Password", placeholder: "Enter your password", description: "You must use at least 8 characters."),
            RegistrationModel(title: "Confirm password", placeholder: "Confirm your password"),
            RegistrationModel(title: "Age", isRequired: false, optionalTextVisible: true, placeholder: "Select your Birthday Date", rightIcon: .downArrow),
            RegistrationModel(title: "Phone Number", isRequired: false, optionalTextVisible: true, placeholder: "+30 694 435 8945", textFieldKeyboardType: .numberPad, countryEmoji: currentCountryFlag),
            RegistrationModel(title: "Nationality", isRequired: false, optionalTextVisible: true, placeholder: "Select your Nationality", rightIcon: .downArrow),
            RegistrationModel(title: "Sex", isRequired: false, optionalTextVisible: true, placeholder: "Select your Sex", rightIcon: .downArrow)
        ]

        data.send(models)
    }

    func fetchCountryCodes() {
        NSLocale.isoCountryCodes.forEach { code in
            if let name = Locale(identifier: localIdentifier).localizedString(forRegionCode: code) {
                countries[code] = name

                if code == regionCode {
                    currentCountryFlag = code.countryFlag()
                }
            }
        }
    }

    private func registerTest() {
        let traveler = Traveler(name: "Chris", surname: "Petimezas", role: UserRole.TRAVELER, email: "chris.petimezas@gmail.com", password: "123456")

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
