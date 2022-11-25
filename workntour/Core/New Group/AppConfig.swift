//
//  AppConfig.swift
//  workntour
//
//  Created by Chris Petimezas on 9/5/22.
//

import Foundation
import FirebaseCore
import SwiftyBeaver
import Networking
import GooglePlaces

enum Environment: String {
    case DEV = "dev"
    case STAGING = "staging"
    case PROD = "prod"
}

extension Environment {
    static var current: Environment {
        #if DEV
        return .DEV
        #elseif STAGING
        return .STAGING
        #else
        return .PROD
        #endif
    }
}

struct AppConfig {

    static var appVersion: String {
        return path("CFBundleShortVersionString")
    }

    static func setupFB() {
        guard let file = Bundle.main.path(forResource: Environment.current.googleService, ofType: ".plist"),
              let options = FirebaseOptions(contentsOfFile: file) else {
                  assertionFailure("Could not configure Firebase! Please check again the API Key.")
                  return
              }

        options.apiKey = "AIzaSyD558vl9MASo_Pr8ZqrO4a1BI9Q70Ul32k"
        FirebaseApp.configure(options: options)
    }

    static func setupGooglePlaces() {
        GMSPlacesClient.provideAPIKey("AIzaSyB6loP2yYIkJeQX477L_Tj16tDFKaQ4ar0")
    }

    static func setupLogger() {
        let consoleDestination = ConsoleDestination()
        consoleDestination.format = "$DHH:mm:ss$d $C$L$c $M"
        SwiftyBeaver.addDestination(consoleDestination)
        SwiftyBeaver.verbose("Running on \(Environment.current.rawValue) configuration")
    }

    static private func path(_ keys: String...) -> String {
        var current = Bundle.main.infoDictionary
        for (index, key) in keys.enumerated() {
            if index == keys.count - 1 {
                guard let
                        result = (current?[key] as? String)?.replacingOccurrences(of: "\\", with: ""),
                      !result.isEmpty else {
                          assertionFailure(keys.joined(separator: " -> ").appending(" not found"))
                          return ""
                      }
                return result
            }
            current = current?[key] as? [String: Any]
        }
        assertionFailure(keys.joined(separator: " -> ").appending(" not found"))
        return ""
    }

}

// MARK: - API
extension Environment {
    var apiBaseURL: URL {
        var urlAsString: String

        switch self {
        case .DEV:
            urlAsString = "https://workntourbackenddevelop.azurewebsites.net"
        case .STAGING:
            urlAsString = "https://workntourbackend.azurewebsites.net"
        case .PROD:
            urlAsString = "not implemented yet!"
        }

        guard let url = URL(string: urlAsString) else {
            assertionFailure("Api Base URL is not valid! Please verify it and try again.")
            return URL(string: urlAsString)!
        }

        return url
    }
}

// MARK: - Firebase
extension Environment {
    var googleService: String {
        switch self {
        case .DEV:
            return "GoogleService-Info.Dev"
        case .STAGING:
            return "GoogleService-Info.Staging"
        case .PROD:
            return "GoogleService-Info.Prod"
        }
    }
}
