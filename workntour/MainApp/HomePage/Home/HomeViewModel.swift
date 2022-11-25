//
//  HomeViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 17/6/22.
//

import Foundation
import Combine

class HomeViewModel: BaseViewModel {
    /// Service
    private var service: HomeService

    /// Inputs
    /// Observe changes when this object has been changed
    var filters: OpportunityFilterDto {
        didSet {
            getOpportunities(resetPagination: true,
                             withFilters: filters)
        }
    }

    /// Outputs
    @Published var data: [OpportunityDto]
    @Published var errorMessage: String?
    @Published var opportunitiesCoordinates: [OpportunityCoordinateModel]
    @Published var mapIsHidden: Bool = true
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
            self?.mapIsHidden = true

            return Just([])
        })
            .assign(to: &$data)
    }

    func resetPagination() {
        data = []
        totalNumOfOpportunities = 0
        start = 0
        noMoreOpportunities = false
        errorMessage = nil
        mapIsHidden = true
    }

}
