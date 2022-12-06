//
//  IndividualHostProfileDto.swift
//  workntour
//
//  Created by Chris Petimezas on 22/6/22.
//

import Foundation

// MARK: - IndividualHostProfileDto
struct IndividualHostProfileDto: Codable {
    let memberID: String
    let role: UserRole
    let name, surname, email: String
    var city, address: String?
    var country, countryCode, mobile, fixedNumber: String?
    var description, link, postalAddress: String?
    var profileImage: ProfileImage?
    let createdAt: String?
    
    // MARK: - Init

    init(memberID: String, role: UserRole, name: String, surname: String, email: String, city: String? = nil, address: String? = nil, country: String? = nil, countryCode: String? = nil, mobile: String? = nil, fixedNumber: String? = nil, description: String? = nil, link: String? = nil, postalAddress: String? = nil, image: ProfileImage? = nil, createdAt: String? = nil) {
        self.memberID = memberID
        self.role = role
        self.name = name
        self.surname = surname
        self.email = email
        self.city = city
        self.address = address
        self.country = country
        self.countryCode = countryCode
        self.mobile = mobile
        self.fixedNumber = fixedNumber
        self.description = description
        self.link = link
        self.postalAddress = postalAddress
        self.profileImage = image
        self.createdAt = createdAt
    }

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case role
        case name, surname, email
        case city, address
        case country, fixedNumber, description, link
        case countryCode = "countryCodeMobileNum"
        case mobile = "mobileNum"
        case profileImage
        case postalAddress, createdAt
    }

    // MARK: - Private Properties

    let totalFields: Double = 12

    var fullname: String {
        return "\(name) \(surname)"
    }

    var percents: ProfilePercents {
        var percent: Double = 0.0

        percent += hasValue(name)
        percent += hasValue(surname)
        percent += hasValue(email)
        percent += hasValue(address)
        percent += hasValue(city)
        percent += hasValue(postalAddress)
        percent += hasValue(country)
        percent += hasValue(mobile)
        percent += hasValue(fixedNumber)
        percent += hasValue(description)
        percent += hasValue(link)
        percent += hasValue(profileImage?.url)

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
}

private extension String {
    var hasValue: Bool {
        return !self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
