//
//  Authorization+DataManager.swift
//  workntour
//
//  Created by Chris Petimezas on 9/5/23.
//

import Combine
import Networking

// MARK: - AuthorizationService
extension DataManager: AuthorizationService {

    func travelerRegistration(model: Traveler) -> AnyPublisher<String?, ProviderError> {
        return networking.request(
            with: AuthorizationRouter.registerTraveler(model),
            scheduler: DispatchQueue.main,
            class: GenericResponse<Traveler>.self)
        .map { $0.data?.email }
        .eraseToAnyPublisher()
    }

    func individualHostRegistration(model: IndividualHost) -> AnyPublisher<String?, ProviderError> {
        return networking.request(
            with: AuthorizationRouter.registerHostIndividual(model),
            scheduler: DispatchQueue.main,
            class: GenericResponse<IndividualHost>.self)
        .map { $0.data?.email }
        .eraseToAnyPublisher()
    }

    func companyHostRegistration(model: CompanyHost) -> AnyPublisher<String?, ProviderError> {
        return networking.request(
            with: AuthorizationRouter.registerHostCompany(model),
            scheduler: DispatchQueue.main,
            class: GenericResponse<CompanyHost>.self)
        .map { $0.data?.email }
        .eraseToAnyPublisher()
    }

    func login(email: String, password: String) -> AnyPublisher<LoginModel, ProviderError> {
        return networking.request(
            with: AuthorizationRouter.login(email: email, password: password),
            scheduler: DispatchQueue.main,
            class: GenericResponse<LoginModel>.self)
        .compactMap { $0.data }
        .eraseToAnyPublisher()
    }

    func verifyRegistration(with token: String) -> AnyPublisher<Bool, ProviderError> {
        return networking.request(
            with: AuthorizationRouter.verifyRegistration(token: token),
            scheduler: DispatchQueue.main,
            class: GenericResponse<String>.self
        )
        .compactMap { $0.data != nil }
        .eraseToAnyPublisher()
    }

    func updateVerificationRegistration(with token: String) -> AnyPublisher<Bool, ProviderError> {
        return networking.request(
            with: AuthorizationRouter.updateVerifyRegistration(token: token),
            scheduler: DispatchQueue.main,
            class: GenericResponse<String>.self
        )
        .compactMap { $0.data != nil }
        .eraseToAnyPublisher()
    }

    func forgotPassword(email: String) -> AnyPublisher<Bool, ProviderError> {
        return networking.request(
            with: AuthorizationRouter.forgotPassword(email: email),
            scheduler: DispatchQueue.main,
            class: GenericResponse<String>.self
        )
        .compactMap { $0.data != nil }
        .eraseToAnyPublisher()
    }

    func updatePassword(_ model: PasswordChange) -> AnyPublisher<Bool, ProviderError> {
        return networking.request(
            with: AuthorizationRouter.updatePassword(model),
            scheduler: DispatchQueue.main,
            class: GenericResponse<String>.self
        )
        .compactMap { $0.data != nil }
        .eraseToAnyPublisher()
    }
}
