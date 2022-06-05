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
