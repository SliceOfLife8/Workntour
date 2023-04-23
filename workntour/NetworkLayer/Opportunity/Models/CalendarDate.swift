//
//  CalendarDate.swift
//  workntour
//
//  Created by Chris Petimezas on 30/1/23.
//

import Foundation

/// This struct is used exclusively for HorizonCalendar
struct CalendarDate {
    let start: Date
    let end: Date

    func convertToOpportunityDate() -> OpportunityDates {
        return OpportunityDates(
            start: start.toString(),
            end: end.toString()
        )
    }
}
