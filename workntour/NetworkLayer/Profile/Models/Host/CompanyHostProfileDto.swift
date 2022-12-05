//
//  CompanyHostProfileDto.swift
//  workntour
//
//  Created by Chris Petimezas on 22/6/22.
//

import Foundation
import SharedKit

// MARK: - CompanyHostProfileDto

struct CompanyHostProfileDto: Codable {
    let memberID: String
    let role: UserRole
    var name: String
    let email: String
    var city, address: String?
    var country, postalAddress: String?
    var countryCode, mobile, fixedNumber: String?
    var vat: String?
    var profileImage: ProfileImage?
    var doc: AuthorizedDoc?
    var description, link: String?
    let createdAt: String?

    // MARK: - Init
    init(memberID: String, role: UserRole, name: String, email: String, city: String? = nil, address: String? = nil, country: String? = nil, postalAddress: String? = nil, countryCode: String? = nil, mobile: String? = nil, fixedNumber: String? = nil, vat: String? = nil, profileImage: ProfileImage? = nil, doc: AuthorizedDoc? = nil, description: String? = nil, link: String? = nil, createdAt: String? = nil) {
        self.memberID = memberID
        self.role = role
        self.name = name
        self.email = email
        self.city = city
        self.address = address
        self.country = country
        self.postalAddress = postalAddress
        self.countryCode = countryCode
        self.mobile = mobile
        self.fixedNumber = fixedNumber
        self.vat = vat
        self.profileImage = profileImage
        self.doc = doc
        self.description = description
        self.link = link
        self.createdAt = createdAt
    }

    // MARK: - Private Properties

    let totalFields: Double = 13

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case role, email
        case countryCode = "countryCodeMobileNum"
        case mobile = "mobileNum"
        case name = "companyName"
        case city, address, country
        case postalAddress, fixedNumber, profileImage
        case doc = "authorizedDoc"
        case vat = "vatNumber"
        case description, link, createdAt
    }

    var percents: ProfilePercents {
        var percent: Double = 0.0

        percent += hasValue(name)
        percent += hasValue(email)
        percent += hasValue(address)
        percent += hasValue(city)
        percent += hasValue(postalAddress)
        percent += hasValue(country)
        percent += hasValue(mobile)
        percent += hasValue(fixedNumber)
        percent += hasValue(vat)
        percent += hasValue(description)
        percent += hasValue(link)
        percent += hasValue(profileImage?.url)
        percent += hasValue(doc?.url)

        let roundedPercent = percent.rounded(toPlaces: 2)
        let percent100 = Int(roundedPercent*100)
        let percent360 = roundedPercent*360
        let animationDuration: Double = (percent100 <= 50) ? 1 : 1.5

        return .init(percent360: percent360,
                     percent100: percent100,
                     duration: animationDuration)
    }

    // MARK: - Methods

    func hasValue(_ text: String?) -> Double {
        guard let text else { return 0 }
        return !text.trimmingCharacters(in: .whitespaces).isEmpty
        ? 1/totalFields
        : 0
    }

    func getProfileImage() -> URL? {
        guard let firstValue = profileImage?.url
        else {
            return nil
        }

        return URL(string: firstValue)
    }

    func getDocumentName() -> String? {
        guard let _ = doc?.url
        else {
            return nil
        }

        return "Document"
    }
}
