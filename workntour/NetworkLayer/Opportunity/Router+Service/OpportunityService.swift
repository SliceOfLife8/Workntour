//
//  OpportunityService.swift
//  workntour
//
//  Created by Chris Petimezas on 2/7/22.
//

import Combine
import Networking

protocol OpportunityService: AnyObject {

    func createOpportunity(_ model: OpportunityDto) -> AnyPublisher<Bool, ProviderError>

    func getOpportunities(id: String) -> AnyPublisher<[OpportunityDto]?, ProviderError>

    func getOpportunity(byId opportunityId: String) -> AnyPublisher<OpportunityDto, ProviderError>

    func deleteOpportunity(byId opportunityId: String) -> AnyPublisher<Bool, ProviderError>

}
