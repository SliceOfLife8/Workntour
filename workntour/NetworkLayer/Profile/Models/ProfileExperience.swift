//
//  ProfileExperience.swift
//  workntour
//
//  Created by Chris Petimezas on 13/11/22.
//

import Foundation

struct ProfileExperience: Codable {
    var type: ExperienceType
    var organization: String?
    var position: String?
    var startDate: String?
    var endDate: String?
    var description: String?

    // All properties are prefilled.
    var isPrefilled: Bool {
        guard let organization,
              let position,
              let startDate,
              let endDate,
              let description
        else {
            return false
        }

        return !organization.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !position.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !startDate.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !endDate.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: - Constructors/Destructors

    init(
        type: ExperienceType,
        organization: String? = nil,
        position: String? = nil,
        startDate: String? = nil,
        endDate: String? = nil,
        description: String? = nil
    ) {
        self.type = type
        self.organization = organization
        self.position = position
        self.startDate = startDate
        self.endDate = endDate
        self.description = description
    }
}

enum ExperienceType: String, Codable {
    case professional
    case education

    var value: String {
        switch self {
        case .professional:
            return "Professional"
        case .education:
            return "Education"
        }
    }
}
