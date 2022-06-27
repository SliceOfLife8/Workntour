//
//  CompanyHostProfile.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 22/6/22.
//

import Foundation

// MARK: - CompanyHostProfile
struct CompanyHostProfile: Codable {
    let memberID: String
    let role: UserRole
    let name, companyID: String
    let email, password: String
    let country, postalAddress: String?
    let countryCode, mobile, fixedNumber, profileImage: String?
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
}
