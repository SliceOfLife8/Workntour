//
//  UIButton+Extensions.swift
//  SharedKit
//
//  Created by Chris Petimezas on 9/6/22.
//

import UIKit

public extension UIButton {
    func underline() {
        guard let text = self.currentTitle else {
            return
        }

        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))

        self.setAttributedTitle(attributedString, for: .normal)
    }
}
