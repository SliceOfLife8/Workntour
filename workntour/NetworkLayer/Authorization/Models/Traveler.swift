//
//  Traveler.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 10/5/22.
//

import Foundation

// MARK: - Traveler
struct Traveler: Codable {
    let name, surname: String
    let role: UserRole
    let email, password: String
    let memberID, countryCode, mobile, nationality: String?
    let sex: UserSex?
    let birthday: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case countryCode = "countryCodeMobileNum"
        case mobile = "mobileNum"
        case name, surname, role, email, password
        case nationality, sex
        case birthday, createdAt
    }

    init(name: String, surname: String, role: UserRole, email: String, password: String, memberID: String? = nil,
         countryCode: String? = nil, mobile: String? = nil, nationatility: String? = nil, sex: UserSex? = nil,
         birthday: String? = nil, createdAt: String? = nil) {
        self.name = name
        self.surname = surname
        self.role = role
        self.email = email
        self.password = password
        self.memberID = memberID
        self.countryCode = countryCode
        self.mobile = mobile
        self.nationality = nationatility
        self.sex = sex
        self.birthday = birthday
        self.createdAt = createdAt
    }
}

enum UserRole: String, Codable {
    case TRAVELER
    case INDIVIDUAL_HOST
    case COMPANY_HOST
}

enum UserSex: String, Codable {
    case MALE
    case FEMALE
    case OTHER
}
