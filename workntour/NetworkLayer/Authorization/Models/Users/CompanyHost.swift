//
//  CompanyHost.swift
//  workntour
//
//  Created by Chris Petimezas on 25/5/22.
//

import Foundation

// MARK: - CompanyHost
struct CompanyHost: Codable {
    let role: UserRole
    let name, email, password: String
    let id, memberID, country, countryCode, mobile, tel: String?
    let sex: UserSex?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "companyId"
        case memberID = "memberId"
        case countryCode = "countryCodeMobileNum"
        case mobile = "mobileNum"
        case country = "headquartersCounty"
        case name = "companyName"
        case role, email, password, tel
        case sex, createdAt
    }

    init(name: String, role: UserRole, email: String, password: String, id: String? = nil,
         memberID: String? = nil, country: String? = nil, countryCode: String? = nil,
         mobile: String? = nil, tel: String? = nil, sex: UserSex? = nil,
         createdAt: String? = nil) {
        self.name = name
        self.role = role
        self.email = email
        self.password = password
        self.id = id
        self.memberID = memberID
        self.country = country
        self.countryCode = countryCode
        self.mobile = mobile
        self.tel = tel
        self.sex = sex
        self.createdAt = createdAt
    }
}
