//
//  OpportunityDetailsModel.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 5/7/22.
//

import Foundation

struct OpportunityDetailsModel {
    let title: String?
    let description: String?
    let showDates: Bool
    let showDays: Bool
    let location: OpportunityLocation?

    init(title: String? = nil, description: String? = nil, dates: Bool = false, showDays: Bool = false, location: OpportunityLocation? = nil) {
        self.title = title
        self.description = description
        self.showDates = dates
        self.showDays = showDays
        self.location = location
    }
}

struct OpportunityDetailsHeaderModel {
    let title: String
    let area: String?
    let category: OpportunityCategory
}
