//
//  AppConfig.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 9/5/22.
//

import Foundation
import FirebaseCore
import Keys

enum Environment {
    case DEV
    case STAGING
    case PROD

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

struct AppConfig {

    static var appVersion: String {
        return path("CFBundleShortVersionString")
    }

    static func setupFB() {
        guard let file = Bundle.main.path(forResource: Environment.DEV.googleService, ofType: ".plist"),
              let options = FirebaseOptions(contentsOfFile: file) else {
                  assertionFailure("Could not configure Firebase! Please check again the API Key.")
                  return
              }
        
        options.apiKey = WorkntourKeys().googleServiceDevApiKey
        FirebaseApp.configure(options: options)
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
