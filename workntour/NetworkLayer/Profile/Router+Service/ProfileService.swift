//
//  ProfileService.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 22/6/22.
//

import Combine
import Networking

protocol ProfileService: AnyObject {

    func getTravelerProfile(memberId: String) -> AnyPublisher<Bool, ProviderError>

    func getIndividualHostProfile(memberId: String) -> AnyPublisher<Bool, ProviderError>

    func getCompanyHostProfile(memberId: String) -> AnyPublisher<Bool, ProviderError>

    func updateTravelerProfile(model: TravelerProfile) -> AnyPublisher<TravelerProfile?, ProviderError>

    func updateIndividualHostProfile(model: IndividualHostProfile) -> AnyPublisher<IndividualHostProfile?, ProviderError>

    func updateCompanyHostProfile(model: CompanyHostProfile) -> AnyPublisher<CompanyHostProfile?, ProviderError>

}
