//
//  TravelerProfile.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 22/6/22.
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
    let profileImage: [ProfileImage]?
    var interests: [LearningOpportunities]?
    var languages: [ProfileLanguage]?
    var skills: [TypeOfHelp]?
    var experience: [ProfileExperience]?
    var specialDietary: SpecialDietary?
    var driverLicense: Bool?
    let imageData: Data?
    let createdAt: String?

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

        percent += name.hasValue ? 1/9 : 0
        percent += surname.hasValue ? 1/9 : 0
        percent += (nationality?.hasValue == true) ? 1/9 : 0
        percent += (birthday?.hasValue == true) ? 1/9 : 0
        percent += (sex != .none) ? 1/9 : 0
        percent += email.hasValue ? 1/9 : 0
        percent += (postalAddress?.hasValue == true) ? 1/9 : 0
        percent += (mobile?.hasValue == true) ? 1/9 : 0
        percent += (type != .none) ? 1/9 : 0

        let roundedPercent = percent.rounded(toPlaces: 2)
        let percent100 = Int(roundedPercent*100)
        let percent360 = roundedPercent*360
        let animationDuration: Double = (percent100 <= 50) ? 1 : 1.5

        return .init(percent360: percent360,
                     percent100: percent100,
                     duration: animationDuration)
    }
}

struct ProfilePercents {
    let percent360: Double
    let percent100: Int
    let duration: Double
}

private extension String {
    var hasValue: Bool {
        return !self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
