//
//  AuthorizationService.swift
//  workntour
//
//  Created by Chris Petimezas on 11/5/22.
//

import Combine
import Networking

protocol AuthorizationService: AnyObject {

    // MARK: - Registration

    func travelerRegistration(model: Traveler) -> AnyPublisher<String?, ProviderError>

    func individualHostRegistration(model: IndividualHost) -> AnyPublisher<String?, ProviderError>

    func companyHostRegistration(model: CompanyHost) -> AnyPublisher<String?, ProviderError>

    func verifyRegistration(with token: String) -> AnyPublisher<Bool, ProviderError>

    func updateVerificationRegistration(with token: String) -> AnyPublisher<Bool, ProviderError>

    // MARK: - Login

    func login(email: String, password: String) -> AnyPublisher<LoginModel, ProviderError>

    // MARK: - Forgot Password

    func forgotPassword(email: String) -> AnyPublisher<Bool, ProviderError>

    func updatePassword(_ model: PasswordChange) -> AnyPublisher<Bool, ProviderError>

}
