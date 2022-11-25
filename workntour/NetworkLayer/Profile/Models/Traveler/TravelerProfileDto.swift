//
//  TravelerProfile.swift
//  workntour
//
//  Created by Chris Petimezas on 22/6/22.
//

import Foundation

// MARK: - TravelerProfile
struct TravelerProfileDto: Codable {
    let memberID: String
    let role: UserRole
    var name, surname, email: String
    var birthday: String?
    var sex: UserSex?
    var mobile, countryCode, nationality, postalAddress: String?
    var address, city, country: String?
    var type: TravelerType?
    var description: String?
    private let profileImage: [String: String]?
    var interests: [LearningOpportunities]?
    var languages: [ProfileLanguage]?
    var skills: [TypeOfHelp]?
    var experience: [ProfileExperience]?
    var specialDietary: SpecialDietary?
    var driverLicense: Bool?
    let imageData: Data?
    let createdAt: String?

    // MARK: - Private Properties

    let totalFields: Double = 18

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case role, name, surname, email, birthday, nationality, sex, postalAddress
        case countryCode = "countryCodeMobileNum"
        case mobile = "mobileNum"
        case address, city, country
        case type = "typeOfTraveler"
        case interests, languages, skills, experience
        case profileImage, description
        case driverLicense, specialDietary
        case imageData = "imageMobile"
        case createdAt
    }

    var fullname: String {
        return "\(name) \(surname)"
    }

    var percents: ProfilePercents {
        var percent: Double = 0.0

        percent += profileImage.isNilOrEmpty ? 0 : 1/totalFields
        percent += hasValue(name)
        percent += hasValue(surname)
        percent += hasValue(nationality)
        percent += hasValue(birthday)
        percent += sex != .none ? 1/totalFields : 0
        percent += hasValue(email)
        percent += hasValue(address)
        percent += hasValue(city)
        percent += hasValue(postalAddress)
        percent += hasValue(mobile)
        percent += hasValue(description)
        percent += type != .none ? 1/totalFields : 0
        percent += interests.isNilOrEmpty ? 0 : 1/totalFields
        percent += skills.isNilOrEmpty ? 0 : 1/totalFields
        percent += languages.isNilOrEmpty ? 0 : 1/totalFields
        percent += experience.isNilOrEmpty ? 0 : 1/totalFields

        let roundedPercent = percent.rounded(toPlaces: 2)
        let percent100 = Int(roundedPercent*100)
        let percent360 = roundedPercent*360
        let animationDuration: Double
        if percent100 < 40 {
            animationDuration = 0.8
        }
        else if percent100 < 75 {
            animationDuration = 1.2
        }
        else {
            animationDuration = 1.5
        }

        return .init(percent360: percent360,
                     percent100: percent100,
                     duration: animationDuration)
    }

    func hasValue(_ text: String?) -> Double {
        guard let text else { return 0 }
        return !text.trimmingCharacters(in: .whitespaces).isEmpty
        ? 1/totalFields
        : 0
    }

    func getProfileImage() -> URL? {
        guard let firstValue = profileImage?.values.first
        else {
            return nil
        }

        return URL(string: firstValue)
    }
}

struct ProfilePercents {
    let percent360: Double
    let percent100: Int
    let duration: Double
}

private extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        switch self {
            case .some(let collection):
                return collection.isEmpty
            case .none:
                return true
        }
    }
}
