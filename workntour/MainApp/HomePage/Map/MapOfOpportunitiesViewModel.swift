//
//  MapOfOpportunitiesViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 22/7/22.
//

import Foundation
import Combine

class MapOfOpportunitiesViewModel: BaseViewModel {
    /// Service
    private(set) var service: HomeService
    private(set) var longitude: Double
    private(set) var latitude: Double

    /// Outputs
    @Published var opportunitiesCoordinates: [OpportunityCoordinateModel]

    init(service: HomeService = DataManager.shared,
         longitude: Double,
         latitude: Double) {
        self.service = service
        self.longitude = longitude
        self.latitude = latitude
        self.opportunitiesCoordinates = []

        super.init()
    }

    func getOpportunitiesCoordsByLocation() {
        service.getOpportunitiesCoordinatesByLocation(longitude: longitude,
                                                      latitude: latitude)
        .subscribe(on: RunLoop.main)
        .catch({ _ -> Just<[OpportunityCoordinateModel]> in
            return Just([])
        })
            .assign(to: &$opportunitiesCoordinates)
    }

}
