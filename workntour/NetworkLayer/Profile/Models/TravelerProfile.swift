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
    let name, surname: String
    let email, password, birthday: String
    let sex: UserSex?
    let mobile, countryCode, nationality, postalAddress: String?
    let welcomeDescription, profileImage: String?
    let type: TravelerType?
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
}

enum TravelerType: String, Codable {
    case SOLO_TRAVELER
    case COUPLE
    case FRIENDS
    case CAREER_BREAK
    case GAP_YEAR
    case STUDENT
    case FAMILY
    case DIGITAL_NOMAD
}
