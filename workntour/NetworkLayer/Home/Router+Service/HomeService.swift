//
//  HomeService.swift
//  workntour
//
//  Created by Chris Petimezas on 14/7/22.
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

    /// Get an array of location of opportunities which are related to a specific area.
    /// f.e. retrieve all opportunities of Athens.
    /// - Parameters
    ///   - longitude & latitude
    /// - returns: The array which contains opportunitiesIds & coordinates in order to draw houses at map.
    func getOpportunitiesCoordinatesByLocation(longitude: Double,
                                               latitude: Double) -> AnyPublisher<[OpportunityCoordinateModel], ProviderError>
}
