//
//  NetworkingDebugger.swift
//  Networking
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import Foundation
import SwiftyBeaver

public enum NetworkingDebugger {

    public static func printDebugDescriptionIfNeeded(from urlRequest: URLRequest, error: Error?) {
        guard Preference.shared.isDebuggingEnabled else {
            return
        }
        SwiftyBeaver.info("------------------ OUTGOING ------------------")

        defer { SwiftyBeaver.info("------------------ END ------------------") }
        let urlAsString = urlRequest.url?.absoluteString ?? ""
        let method = urlRequest.httpMethod ?? ""

        SwiftyBeaver.verbose("URL -> \(urlAsString), METHOD -> \(method)")

        urlRequest.allHTTPHeaderFields?.forEach {
            SwiftyBeaver.verbose("HEADERS -> \($0): \($1)")
        }

        guard let err = error else {
            SwiftyBeaver.verbose("STATUS: SUCCESS")
            return
        }
        SwiftyBeaver.error("STATUS: FAILED.\nERROR: \(err.localizedDescription)")
    }
}
