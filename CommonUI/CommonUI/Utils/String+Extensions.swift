//
//  String+Extensions.swift
//  CommonUI
//
//  Created by Chris Petimezas on 29/6/22.
//

import Foundation

extension String {
    func opportunityDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else {
            return ""
        }

        dateFormatter.dateFormat = "MMM dd, YYYY"
        return dateFormatter.string(from: date)
    }
}
