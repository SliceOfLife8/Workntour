//
//  Language.swift
//  workntour
//
//  Created by Chris Petimezas on 19/11/22.
//

import Foundation

// MARK: - Language
enum Language: String, CaseIterable, Codable {
    case GREEK
    case ENGLISH
    case SPANISH
    case ITALIAN
    case GERMAN
    case DUTCH
    case SWEDISH
    case NORWEGIAN
    case POLISH
    case PORTUGUESE
    case SERBIAN
    case CROATIAN
    case BULGARIAN

    var value: String {
        switch self {
        case .GREEK:
            return "🇬🇷 Greek"
        case .ENGLISH:
            return "🇬🇧 English"
        case .SPANISH:
            return "🇪🇸 Spanish"
        case .ITALIAN:
            return "🇮🇹 Italian"
        case .GERMAN:
            return "🇩🇪 German"
        case .DUTCH:
            return "🇳🇱 Dutch"
        case .SWEDISH:
            return "🇸🇪 Swedish"
        case .NORWEGIAN:
            return "🇳🇴 Norwegian"
        case .POLISH:
            return "🇵🇱 Polish"
        case .PORTUGUESE:
            return "🇵🇹 Portuguese"
        case .SERBIAN:
            return "🇷🇸 Serbian"
        case .CROATIAN:
            return "🇭🇷 Croatian"
        case .BULGARIAN:
            return "🇧🇬 Bulguarian"
        }
    }

    init?(caseName: String) {
        for key in Language.allCases where "\(key.value)" == caseName {
            self = key
            return
        }

        return nil
    }
}

// MARK: - LanguageProficiency
enum LanguageProficiency: String, CaseIterable, Codable {
    case BEGINNER
    case INTERMEDIATE
    case FLUENT

    var value: String {
        switch self {
        case .BEGINNER:
            return "Beginner"
        case .INTERMEDIATE:
            return "Intermediate"
        case .FLUENT:
            return "Fluent"
        }
    }

    var intValue: Int {
        switch self {
        case .BEGINNER:
            return 0
        case .INTERMEDIATE:
            return 1
        case .FLUENT:
            return 2
        }
    }

    init?(_ value: Int) {
        for key in LanguageProficiency.allCases where key.intValue == value {
            self = key
            return
        }

        return nil
    }

    init?(caseName: String) {
        for key in LanguageProficiency.allCases where "\(key.value)" == caseName {
            self = key
            return
        }

        return nil
    }
}
