//
//  IndividualHost.swift
//  workntour
//
//  Created by Chris Petimezas on 25/5/22.
//

import Foundation

// MARK: - IndividualHost
struct IndividualHost: Codable {
    let name, surname: String
    let role: UserRole
    let email, password: String
    let memberID, countryCode, mobile, tel, nationality: String?
    let sex: UserSex?
    let country, birthday, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case countryCode = "countryCodeMobileNum"
        case mobile = "mobileNum"
        case name, surname, role, email, password
        case nationality, sex, tel
        case country, birthday, createdAt
    }

    init(name: String, surname: String, role: UserRole, email: String, password: String, memberID: String? = nil,
         countryCode: String? = nil, mobile: String? = nil, tel: String? = nil, nationatility: String? = nil, sex: UserSex? = nil, country: String? = nil,
         birthday: String? = nil, createdAt: String? = nil) {
        self.name = name
        self.surname = surname
        self.role = role
        self.email = email
        self.password = password
        self.memberID = memberID
        self.countryCode = countryCode
        self.mobile = mobile
        self.tel = tel
        self.nationality = nationatility
        self.sex = sex
        self.country = country
        self.birthday = birthday
        self.createdAt = createdAt
    }
}
