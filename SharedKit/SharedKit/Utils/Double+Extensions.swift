//
//  Double+Extensions.swift
//  SharedKit
//
//  Created by Chris Petimezas on 30/7/22.
//

import Foundation

public extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
