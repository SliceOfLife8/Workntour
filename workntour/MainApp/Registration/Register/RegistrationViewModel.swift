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
    var countries = PassthroughSubject<[String: String], Never>()

    @Published private(set) var hole: Void
    @Published private(set) var errorMessage: String?

    init(service: AuthorizationService = DataManager.shared) {
        self.service = service
        self.hole = ()
        self.input = PassthroughSubject<Void, Never>()

        super.init()
    }

    func fetchModels() {
        var dict: [String: String] = [:]
        var flag: String?
        NSLocale.isoCountryCodes.forEach { code in
            if let name = Locale(identifier: localIdentifier).localizedString(forRegionCode: code) {
                dict[code] = name

                if code == regionCode {
                    flag = code.countryFlag()
                }
            }
        }

        let models: [RegistrationModel] = [
            RegistrationModel(title: "Fullname", placeholder: "Enter your fullname"),
            RegistrationModel(title: "Email", placeholder: "Enter your email", textFieldKeyboardType: .emailAddress),
            RegistrationModel(title: "Password", placeholder: "Enter your password", description: "You must use at least 8 characters."),
            RegistrationModel(title: "Confirm password", placeholder: "Confirm your password"),
            RegistrationModel(title: "Age", isOptional: true, placeholder: "Select your Birthday Date", rightIcon: .upArrow),
            RegistrationModel(title: "Phone Number", isOptional: true, placeholder: "+30 694 435 8945", textFieldKeyboardType: .numberPad, countryEmoji: flag)
        ]

        data.send(models)
    }

    func fetchCountryCodes() {
        var dict: [String: String] = [:]
        NSLocale.isoCountryCodes.forEach { code in
            if let name = Locale(identifier: localIdentifier).localizedString(forRegionCode: code) {
                dict[code] = name
            }
        }

        countries.send(dict)
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
