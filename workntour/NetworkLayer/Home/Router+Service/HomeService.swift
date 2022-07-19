//
//  HomeService.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 14/7/22.
//

import Combine
import Networking

protocol HomeService: AnyObject {

    /// Get all opportunities with pagination.
    /// - Parameters
    ///   - start: The current page
    ///   - offset: Actual size of page
    ///   - filters:  This refers to filters object
    /// - returns: 1. List of opportunities 2. The total available opportunities 3. hasNext is true when new page exists.
    func getAllOpportunities(start: Int, offset: Int, filters: OpportunityFilterDto?) -> AnyPublisher<(opportunities: [OpportunityDto], totalNumber: Int, hasNext: Bool), ProviderError>

    /// Get number of opportunities when selecting filters.
    /// - Parameters
    ///   - body: Filters Dto
    /// - returns: The actual number of opportunities.
    func getNumberOfResults(body: OpportunityFilterDto) -> AnyPublisher<Int, ProviderError>

}
