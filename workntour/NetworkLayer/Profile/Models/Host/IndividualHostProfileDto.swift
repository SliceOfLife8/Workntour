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
    let name, surname: String
    let email, password, birthday: String
    var country, countryCode, mobile, fixedNumber, nationality: String?
    var description, postalAddress: String?
    var image: Data?
    var sex: UserSex?
    let createdAt: String?

    // MARK: - Init
    init(memberID: String, role: UserRole, name: String, surname: String, email: String, password: String, birthday: String, country: String? = nil, countryCode: String? = nil, mobile: String? = nil, fixedNumber: String? = nil, nationality: String? = nil, description: String? = nil, postalAddress: String? = nil, image: Data? = nil, sex: UserSex? = nil, createdAt: String?) {
        self.memberID = memberID
        self.role = role
        self.name = name
        self.surname = surname
        self.email = email
        self.password = password
        self.birthday = birthday
        self.country = country
        self.countryCode = countryCode
        self.mobile = mobile
        self.fixedNumber = fixedNumber
        self.nationality = nationality
        self.description = description
        self.postalAddress = postalAddress
        self.image = image
        self.sex = sex
        self.createdAt = createdAt
    }

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
