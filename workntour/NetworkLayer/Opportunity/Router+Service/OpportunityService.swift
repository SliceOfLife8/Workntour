//
//  OpportunityService.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 2/7/22.
//

import Combine
import Networking

protocol OpportunityService: AnyObject {

    func createOpportunity(_ model: OpportunityDto) -> AnyPublisher<Bool, ProviderError>

    func getOpportunities(id: String) -> AnyPublisher<[OpportunityDto], ProviderError>

}