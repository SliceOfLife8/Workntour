//
//  String+Extensions.swift
//  SharedKit
//
//  Created by Petimezas, Chris, Vodafone on 10/5/22.
//

import Foundation

extension String {
    private var emailPredicate: NSPredicate {
        let userid = "[A-Z0-9a-z._%+-]{1,}"
        let domain = "([A-Z0-9a-z._%+-]{1,}\\.){1,}"
        let regex = userid + "@" + domain + "[A-Za-z]{1,}"
        return NSPredicate(format: "SELF MATCHES %@", regex)
    }

    func isEmailValid() -> Bool {
        return emailPredicate.evaluate(with: self)
    }
}
