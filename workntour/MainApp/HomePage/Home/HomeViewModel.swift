//
//  HomeViewModel.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 17/6/22.
//

import Foundation
import Combine

class HomeViewModel: BaseViewModel {
    /// Service
    private var service: HomeService

    /// Inputs
    /// Observe changes when this object has been changed
    @Published var filters: OpportunityFilterDto

    /// Outputs
    @Published var data: [OpportunityDto]
    @Published var errorMessage: String?
    @Published var opportunitiesCoordinates: [OpportunityCoordinateModel]
    /// Pagination vars
    var collectionViewIsUpdating: Bool = false
    var totalNumOfOpportunities: Int = 0
    var start: Int = 0
    var numberOfOpportunitiesBatch: Int = 10
    var noMoreOpportunities: Bool = false

    init(service: HomeService = DataManager.shared) {
        self.service = service
        self.data = []
        self.filters = OpportunityFilterDto()
        self.opportunitiesCoordinates = []

        super.init()
    }

    func getOpportunities(resetPagination reset: Bool = false,
                          withFilters filters: OpportunityFilterDto? = nil) {
        collectionViewIsUpdating = true
        if reset {
            resetPagination()
        }

        service.getAllOpportunities(start: start,
                                    offset: numberOfOpportunitiesBatch,
                                    filters: filters)
        .map {
            /// Pagination logic
            self.totalNumOfOpportunities = $0.totalNumber
            self.start += 1
            /// If opportunities are less than expected or there isn't a new page
            if $0.opportunities.count < self.numberOfOpportunitiesBatch || !$0.hasNext {
                self.noMoreOpportunities = true
            }

            return self.data + $0.opportunities
        }
        .subscribe(on: RunLoop.main)
        .catch({ [weak self] _ -> Just<[OpportunityDto]> in
            self?.errorMessage = "Opportunities were not found"

            return Just([])
        })
            .assign(to: &$data)
    }

    func getOpportunitiesCoordsByLocation() {
        guard let long = filters.longitude,
              let lat = filters.latitude else {
            assertionFailure()
            return
        }

        loaderVisibility = true
        service.getOpportunitiesCoordinatesByLocation(longitude: long,
                                                      latitude: lat)
        .subscribe(on: RunLoop.main)
        .catch({ _ -> Just<[OpportunityCoordinateModel]> in
            return Just([])
        })
            .handleEvents(receiveCompletion: { _ in
                self.loaderVisibility = false
            })
            .assign(to: &$opportunitiesCoordinates)
    }

    func resetPagination() {
        data = []
        totalNumOfOpportunities = 0
        start = 0
        noMoreOpportunities = false
        errorMessage = nil
    }

}
