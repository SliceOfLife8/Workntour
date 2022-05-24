//
//  AuthorizationService.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 11/5/22.
//

import Combine
import Networking

protocol AuthorizationService: AnyObject {

    func userRegistration(traveler: Traveler) -> AnyPublisher<Void, ProviderError>

}
