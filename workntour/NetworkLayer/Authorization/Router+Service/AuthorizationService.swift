//
//  AuthorizationService.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 11/5/22.
//

import Combine
import Networking

protocol AuthorizationService: AnyObject {

    func travelerRegistration(model: Traveler) -> AnyPublisher<Bool, ProviderError>

    func individualHostRegistration(model: IndividualHost) -> AnyPublisher<Void, ProviderError>

    func companyHostRegistration(model: CompanyHost) -> AnyPublisher<Void, ProviderError>

}
