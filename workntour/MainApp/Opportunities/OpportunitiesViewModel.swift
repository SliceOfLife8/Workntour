//
//  OpportunitiesViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 17/6/22.
//

import Foundation
import Combine

class OpportunitiesViewModel: BaseViewModel {
    /// Service
    private var service: OpportunityService

    /// Outputs
    @Published var data: [OpportunityDto]?
    @Published var errorMessage: String?

    init(service: OpportunityService = DataManager.shared) {
        self.service = service

        super.init()
    }

    func fetchModels() {
        service.getOpportunities(id: UserDataManager.shared.memberId ?? "")
            .subscribe(on: RunLoop.main)
            .catch({ [weak self] error -> Just<[OpportunityDto]?> in
                self?.errorMessage = error.errorDescription

                return Just(nil)
            })
                .assign(to: &$data)
    }
}
