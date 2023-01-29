//
//  OpportunitySelectDates.swift
//  workntour
//
//  Created by Chris Petimezas on 29/1/23.
//

import Foundation

struct OpportunitySelectDates: Hashable, Codable {
    var minimumDays: Int
    var maximumDays: Int
    var maxWorkingHours: Int
    var daysOff: Int

    init(opportunity: OpportunityDto) {
        self.minimumDays = opportunity.minDays
        self.maximumDays = opportunity.maxDays
        self.maxWorkingHours = opportunity.workingHours
        self.daysOff = opportunity.daysOff
    }

    init(minDays: Int, maxDays: Int, workingHours: Int, daysOff: Int) {
        self.minimumDays = minDays
        self.maximumDays = maxDays
        self.maxWorkingHours = workingHours
        self.daysOff = daysOff
    }
}
