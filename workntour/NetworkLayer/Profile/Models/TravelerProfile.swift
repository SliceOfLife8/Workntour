//
//  TravelerProfile.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 22/6/22.
//

import Foundation

// MARK: - TravelerProfile
struct TravelerProfile: Codable {
    let memberID: String
    let role: UserRole
    var name, surname, email: String
    let password: String
    var birthday: String?
    var sex: UserSex?
    var mobile, countryCode, nationality, postalAddress: String?
    let welcomeDescription, profileImage: String?
    var type: TravelerType?
    let driverLicense: Bool?
    let wishList, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case role, name, surname, email, password, birthday, nationality, sex, postalAddress
        case countryCode = "countryCodeMobileNum"
        case mobile = "mobileNum"
        case welcomeDescription = "description"
        case type = "typeOfTraveler"
        case profileImage, driverLicense, wishList, createdAt
    }

    var fullname: String {
        return "\(name) \(surname)"
    }

    var percents: (_360: Double, _100: Int, duration: Double) {
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

        return (percent360, percent100, animationDuration)
    }
}

private extension String {
    var hasValue: Bool {
        return !self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
