//
//  NetworkingDebugger.swift
//  Networking
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import Foundation
import SwiftyBeaver

public enum NetworkingDebugger {

    public static func notifyStartExecution() {
        guard Preference.shared.isDebuggingEnabled else {
            return
        }

        let startTime = Date()
        Preference.shared.requestExecutionStarted = startTime
        SwiftyBeaver.info("------------------ REQUEST IS STARTING ------------------ [\(startTime.getTime())]")
    }

    public static func printDebugDescriptionIfNeeded(from urlRequest: URLRequest, error: Error?) {
        guard Preference.shared.isDebuggingEnabled else {
            return
        }

        defer {
            let executionTime = Date().timeIntervalSince(Preference.shared.requestExecutionStarted)
            let roundValue = round(1000 * executionTime) / 1000
            SwiftyBeaver.info("------------------ END OF REQUEST ------------------ [\(Date().getTime())] [EXECUTION TIME: \(roundValue)]")
        }
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

        SwiftyBeaver.error("STATUS: FAILED.\nERROR: \(err.localizedDescription)\n")
    }
}

private extension Date {
    func getTime()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
