//
//  Experience.swift
//  workntour
//
//  Created by Chris Petimezas on 13/11/22.
//

import Foundation
import CommonUI

struct ProfileExperience: Codable {
    let uuid: String
    let experience: Experience

    func convertToCommonUI() -> ProfileExperienceCell.DataModel.ExperienceUI? {
        return .init(
            uuid: uuid,
            professional: experience.type == .COMPANY,
            organisation: experience.organization ?? "",
            position: experience.position ?? "",
            dateText: "kati"
        )
    }
}

struct Experience: Codable {
    var type: ExperienceType
    var organization: String?
    var position: String?
    var startDate: String?
    var endDate: String?
    var description: String?

    enum CodingKeys: String, CodingKey {
        case type
        case organization = "nameOfOrganisation"
        case startDate = "startedOn"
        case endDate = "endedOn"
        case position, description
    }

    // All properties are prefilled.
    var isPrefilled: Bool {
        guard let position,
              let startDate,
              let endDate,
              let description
        else {
            return false
        }

        return !position.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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

enum ExperienceType: CaseIterable, Codable {
    case COMPANY
    case UNIVERSITY

    var value: String {
        switch self {
        case .COMPANY:
            return "Professional"
        case .UNIVERSITY:
            return "Education"
        }
    }

    init?(caseName: String) {
        for key in ExperienceType.allCases where "\(key.value)" == caseName {
            self = key
            return
        }

        return nil
    }
}
