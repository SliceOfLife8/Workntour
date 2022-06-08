//
//  UILabel+Extensions.swift
//  SharedKit
//
//  Created by Petimezas, Chris, Vodafone on 8/6/22.
//

import UIKit

public extension UILabel {
    func setLineHeight(lineHeight: CGFloat) {
        guard let text = self.text else { return }

        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()

        style.lineSpacing = lineHeight
        attributeString.addAttribute(
            .paragraphStyle,
            value: style,
            range: NSMakeRange(0, attributeString.length))

        self.attributedText = attributeString
    }
}
