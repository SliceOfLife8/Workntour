//
//  Preference.swift
//  Networking
//
//  Created by Chris Petimezas on 1/5/22.
//

import Foundation

public class Preference {
    static let shared = Preference()

    public var isDebuggingEnabled: Bool = false
    var requestExecutionStarted: Date = Date()
}
