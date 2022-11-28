//
//  NetworkingDebugger.swift
//  Networking
//
//  Created by Chris Petimezas on 1/5/22.
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

    public static func printDebugDescriptionIfNeeded(from urlRequest: URLRequest,
                                                     data: Data?,
                                                     error: ProviderError?,
                                                     statusCode: Int?) {
        guard Preference.shared.isDebuggingEnabled else {
            return
        }

        defer {
            let executionTime = Date().timeIntervalSince(Preference.shared.requestExecutionStarted)
            let roundValue = round(1000 * executionTime) / 1000
            SwiftyBeaver.info("------------------ END OF REQUEST ------------------ [\(Date().getTime())] [EXECUTION TIME: \(roundValue)]")
        }
        let code = statusCode?.stringValue ?? "UknownCode"

        SwiftyBeaver.verbose("CURL:\n \(urlRequest.cURL(pretty: true))")

        guard let error else {
            SwiftyBeaver.verbose("STATUS: SUCCESS (\(code))")
            SwiftyBeaver.info("Response: (\(String(describing: data?.prettyString)))")
            return
        }

        SwiftyBeaver.error("STATUS: FAILED (\(code)).\nERROR: \(error.errorDescription)\n")
    }
}

private extension Date {
    func getTime()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}

private extension Int {
    var stringValue:String {
        return "\(self)"
    }
}

public extension URLRequest {
    func cURL(pretty: Bool = false) -> String {
        let newLine = pretty ? "\\\n" : ""
        let method = (pretty ? "--request " : "-X ") + "\(self.httpMethod ?? "GET") \(newLine)"
        let url: String = (pretty ? "--url " : "") + "\'\(self.url?.absoluteString ?? "")\' \(newLine)"

        var cURL = "curl "
        var header = ""
        var data: String = ""

        if let httpHeaders = self.allHTTPHeaderFields, httpHeaders.keys.count > 0 {
            for (key, value) in httpHeaders {
                header += (pretty ? "--header " : "-H ") + "\'\(key): \(value)\' \(newLine)"
            }
        }

        if let bodyData = self.httpBody, let bodyString = String(data: bodyData, encoding: .utf8), !bodyString.isEmpty {
            data = "--data '\(bodyString)'"
        }

        cURL += method + url + header + data

        return cURL
    }
}

private extension Data {
    var prettyString: NSString? {
        return NSString(data: self, encoding: String.Encoding.utf8.rawValue) ?? nil
    }
}
