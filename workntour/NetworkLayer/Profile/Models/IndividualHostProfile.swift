//
//  IndividualHostProfile.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 22/6/22.
//

import Foundation

// MARK: - IndividualHostProfile
struct IndividualHostProfile: Codable {
    let memberID: String
    let role: UserRole
    let name, surname: String
    let email, password, birthday: String
    var country, countryCode, mobile, fixedNumber, nationality: String?
    var description, postalAddress: String?
    var image: Data?
    var sex: UserSex?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case role
        case name, surname, email, password, birthday
        case country, fixedNumber, nationality, description
        case countryCode = "countryCodeMobileNum"
        case mobile = "mobileNum"
        case image = "profileImage"
        case sex, postalAddress, createdAt
    }

    var fullname: String {
        return "\(name) \(surname)"
    }

    var percents: (_360: Double, _100: Int, duration: Double) {
        var percent: Double = 0.0

        percent += fullname.hasValue ? 1/9 : 0
        percent += email.hasValue ? 1/9 : 0
        percent += (country?.hasValue == true) ? 1/9 : 0
        percent += (postalAddress?.hasValue == true) ? 1/9 : 0
        percent += (mobile?.hasValue == true) ? 1/9 : 0
        percent += (fixedNumber?.hasValue == true) ? 1/9 : 0
        percent += (nationality?.hasValue == true) ? 1/9 : 0
        percent += (sex != nil) ? 1/9 : 0
        percent += (image != nil) ? 1/9 : 0

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
