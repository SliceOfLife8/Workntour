//
//  AuthorizationService.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 11/5/22.
//

import Combine
import Networking

protocol AuthorizationService: AnyObject {

    func travelerRegistration(model: Traveler) -> AnyPublisher<String?, ProviderError>

    func individualHostRegistration(model: IndividualHost) -> AnyPublisher<String?, ProviderError>

    func companyHostRegistration(model: CompanyHost) -> AnyPublisher<String?, ProviderError>

}
