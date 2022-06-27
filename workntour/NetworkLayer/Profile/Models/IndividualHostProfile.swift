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
    let country, countryCode, mobile, fixedNumber, nationality: String?
    let image, description, postalAddress: String?
    let sex: UserSex?
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
}
