//
//  HostProfileSections.swift
//  workntour
//
//  Created by Chris Petimezas on 30/11/22.
//

import Foundation

enum HostProfileSection: Int, CaseIterable {
    case personalInfo = 0
    case description = 1
    case apd = 2

    var value: String {
        switch self {
        case .personalInfo:
            return "Personal Info"
        case .description:
            return "Describe Yourself"
        case .apd:
            return "Authorized Personal Document"
        }
    }
}
