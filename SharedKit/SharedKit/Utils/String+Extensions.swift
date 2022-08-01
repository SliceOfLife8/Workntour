//
//  String+Extensions.swift
//  SharedKit
//
//  Created by Petimezas, Chris, Vodafone on 10/5/22.
//

import Foundation

extension String {
    // MARK: - Email validation
    private var emailPredicate: NSPredicate {
        let userid = "[A-Z0-9a-z._%+-]{1,}"
        let domain = "([A-Z0-9a-z._%+-]{1,}\\.){1,}"
        let regex = userid + "@" + domain + "[A-Za-z]{1,}"
        return NSPredicate(format: "SELF MATCHES %@", regex)
    }

    public func isEmailValid() -> Bool {
        return emailPredicate.evaluate(with: self)
    }

    // MARK: - Password validation
    private var passwordPredicate: NSPredicate {
        // least 1 uppercase, 1 digit, 1 lowercase, 1 symbol
        //  min 8 characters total
        let passwordRegex = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex)
    }

    public func isPasswordValid() -> Bool {
        return passwordPredicate.evaluate(with: self.trimmingCharacters(in: .whitespaces))
    }

    // MARK: - Countries
    public func countryFlag() -> String {
        return String(String.UnicodeScalarView(
            self.unicodeScalars.compactMap(
                { UnicodeScalar(127397 + $0.value) })))
    }

    func range(ofText text: String) -> NSRange {
        let fullText = self
        let range = (fullText as NSString).range(of: text)
        return range
    }

    public func wordExistsOnTappableArea(word: String, index: Int) -> Bool {
        if let range = self.range(of: word) {
            let startPos = self.distance(from: self.startIndex, to: range.lowerBound)
            let endPos = self.distance(from: self.startIndex, to: range.upperBound)

            if startPos...endPos ~= index {
                return true
            }
        }

        return false
    }
}

// MARK: - Dates
extension String {
    public func stringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+00:00")

        return dateFormatter.date(from: self)
    }

    public func changeDateFormat() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = stringToDate() else {
            return self
        }

        return dateFormatter.string(from: date)
    }

    public func asDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return dateFormatter.date(from: self)
    }

    public func userAgeEligibility() -> Bool {
        guard let birthdayDate = self.stringToDate(),
              let minimumRequiredDate = Calendar.current.date(byAdding: .year, value: -18, to: Date()) else {
            return false
        }

        return birthdayDate < minimumRequiredDate
    }
}

// MARK: - Registration Flow
extension String {
    public func trimmingPhoneNumber() -> String {
        var phone: String = ""

        self.components(separatedBy: " ")
            .dropFirst() // remove region code
            .map { $0.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression) }
            .forEach { component in
                phone.append(component)
            }

        return phone
    }
    
    public func getPhoneDetails() -> [String] {
        var details: [String] = []

        self.components(separatedBy: " ")
            .map { $0.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression) }
            .forEach { component in
                details.append(component)
            }

        return details
    }
}
