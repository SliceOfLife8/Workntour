//
//  ProfileService.swift
//  workntour
//
//  Created by Chris Petimezas on 22/6/22.
//

import Combine
import Networking

protocol ProfileService: AnyObject {

    func getTravelerProfile(memberId: String) -> AnyPublisher<Bool, ProviderError>

    func getIndividualHostProfile(memberId: String) -> AnyPublisher<Bool, ProviderError>

    func getCompanyHostProfile(memberId: String) -> AnyPublisher<Bool, ProviderError>

}
