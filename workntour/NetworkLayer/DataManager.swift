//
//  DataManager.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 11/5/22.
//

import Combine
import Networking

/// Data Manager acts as a middle layer (abstraction) between the service(s) and our application.
/// ViewModels are responsible to communite with this layer and pass the data back to Views.
class DataManager {
    static let shared = DataManager()

    private(set) var networking: Networking

    init(networking: Networking = Networking(),
         debugEnabled: Bool = true) {
        self.networking = networking
        self.networking.preference.isDebuggingEnabled = debugEnabled
    }
}

// MARK: - AuthorizationService
extension DataManager: AuthorizationService {

    func travelerRegistration(model: Traveler) -> AnyPublisher<Bool, ProviderError> {
        return networking.request(
            with: AuthorizationRouter.registerTraveler(model),
            scheduler: DispatchQueue.main,
            class: GenericResponse<Traveler>.self)
        .map { $0.data != nil }
        .eraseToAnyPublisher()
    }

    func individualHostRegistration(model: IndividualHost) -> AnyPublisher<Void, ProviderError> {
        return networking.request(
            with: AuthorizationRouter.registerHostIndividual(model),
            scheduler: DispatchQueue.main,
            class: GenericResponse<IndividualHost>.self)
        .map { _ in () }
        .eraseToAnyPublisher()
    }

    func companyHostRegistration(model: CompanyHost) -> AnyPublisher<Void, ProviderError> {
        return networking.request(
            with: AuthorizationRouter.registerHostCompany(model),
            scheduler: DispatchQueue.main,
            class: GenericResponse<CompanyHost>.self)
        .map { _ in () }
        .eraseToAnyPublisher()
    }

}
