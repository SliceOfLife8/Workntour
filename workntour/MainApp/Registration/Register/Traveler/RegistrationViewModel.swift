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

class RegistrationTravelerViewModel: BaseViewModel {
    /// Service
    weak private var service: AuthorizationService?

    // Inputs
    let input: PassthroughSubject<Void, Never>
    // Outputs
    var data = PassthroughSubject<[RegistrationModel], Never>()
    var countries: Countries

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
            RegistrationModel(title: "Fullname", placeholder: "Enter your fullname", type: .name),
            RegistrationModel(title: "Email", placeholder: "Enter your email", type: .email),
            RegistrationModel(title: "Password", placeholder: "Enter your password", type: .password, description: "You must use at least 8 characters."),
            RegistrationModel(title: "Confirm password", placeholder: "Confirm your password", type: .verifyPassword),
            RegistrationModel(title: "Age", placeholder: "Select your Birthday Date", type: .age),
            RegistrationModel(title: "Phone Number", isRequired: false, optionalTextVisible: true, placeholder: "+\(countryPrefix) xxxxxxxxxx",
                              type: .phone, countryEmoji: countries.currentCountryFlag, prefixCode: countryPrefix),
            RegistrationModel(title: "Nationality", isRequired: false, optionalTextVisible: true, placeholder: "Select your Nationality", type: .nationality),
            RegistrationModel(title: "Sex", isRequired: false, optionalTextVisible: true, placeholder: "I am", type: .sex)
        ]

        data.send(models)
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
