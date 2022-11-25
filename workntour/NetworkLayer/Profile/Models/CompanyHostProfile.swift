//
//  CompanyHostProfile.swift
//  workntour
//
//  Created by Chris Petimezas on 22/6/22.
//

import Foundation
import SharedKit

// MARK: - CompanyHostProfile
struct CompanyHostProfile: Codable {
    let memberID: String
    let role: UserRole
    let name, companyID: String
    let email, password: String
    var country, postalAddress: String?
    var countryCode, mobile, fixedNumber: String?
    var profileImage: Data?
    let description, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case role
        case companyID = "companyId"
        case countryCode = "countryCodeMobileNum"
        case mobile = "mobileNum"
        case country = "headquartersCounty"
        case name = "companyName"
        case email, password, postalAddress, fixedNumber, profileImage
        case description, createdAt
    }

    var percents: (_360: Double, _100: Int, duration: Double) {
        var percent: Double = 0.0

        percent += name.hasValue ? 1/7 : 0
        percent += email.hasValue ? 1/7 : 0
        percent += (country?.hasValue == true) ? 1/7 : 0
        percent += (postalAddress?.hasValue == true) ? 1/7 : 0
        percent += (mobile?.hasValue == true) ? 1/7 : 0
        percent += (fixedNumber?.hasValue == true) ? 1/7 : 0
        percent += (profileImage != nil) ? 1/7 : 0

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
