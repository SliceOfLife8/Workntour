//
//  OpportunitiesFiltersViewModel.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 13/7/22.
//

import Foundation
import Combine

class OpportunitiesFiltersViewModel: BaseViewModel {
    /// Services
    private var service: HomeService

    /// Inputs
    var filters: OpportunityFilterDto {
        didSet {
            retrieveOpportunitiesNum()
        }
    }
    @Published var totalOpportunities: Int

    init(service: HomeService = DataManager.shared,
         filters: OpportunityFilterDto?,
         totalOpportunities: Int) {
        self.service = service
        self.filters = filters ?? OpportunityFilterDto()
        self.totalOpportunities = totalOpportunities

        super.init()
    }

    func retrieveOpportunitiesNum() {
        loaderVisibility = true
        service.getNumberOfResults(body: filters)
            .subscribe(on: RunLoop.main)
            .catch({ _ -> Just<Int> in
                return Just(0)
            })
                .handleEvents(receiveCompletion: { _ in
                    self.loaderVisibility = false
                })
                    .assign(to: &$totalOpportunities)
    }

}
