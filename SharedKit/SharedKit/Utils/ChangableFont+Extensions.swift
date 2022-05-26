//
//  ChangableFont+Extensions.swift
//  SharedKit
//
//  Created by Petimezas, Chris, Vodafone on 26/5/22.
//

import UIKit

extension UILabel: ChangableFont {

    public func getText() -> String? {
        return text
    }

    public func set(text: String?) {
        self.text = text
    }

    public func getAttributedText() -> NSAttributedString? {
        return attributedText
    }

    public func set(attributedText: NSAttributedString?) {
        self.attributedText = attributedText
    }

    public func getFont() -> UIFont? {
        return font
    }
}

extension UITextField: ChangableFont {

    public func getText() -> String? {
        return text
    }

    public func set(text: String?) {
        self.text = text
    }

    public func getAttributedText() -> NSAttributedString? {
        return attributedText
    }

    public func set(attributedText: NSAttributedString?) {
        self.attributedText = attributedText
    }

    public func getFont() -> UIFont? {
        return font
    }
}

extension UITextView: ChangableFont {

    public func getText() -> String? {
        return text
    }

    public func set(text: String?) {
        self.text = text
    }

    public func getAttributedText() -> NSAttributedString? {
        return attributedText
    }

    public func set(attributedText: NSAttributedString?) {
        self.attributedText = attributedText
    }

    public func getFont() -> UIFont? {
        return font
    }
}

public extension ChangableFont {

    var rangedAttributes: [RangedAttributes] {
        guard let attributedText = getAttributedText() else {
            return []
        }
        var rangedAttributes: [RangedAttributes] = []
        let fullRange = NSRange(
            location: 0,
            length: attributedText.string.count
        )
        attributedText.enumerateAttributes(
            in: fullRange,
            options: []
        ) { (attributes, range, stop) in
            guard range != fullRange, !attributes.isEmpty else { return }
            rangedAttributes.append(RangedAttributes(attributes, inRange: range))
        }
        return rangedAttributes
    }

    func changeFont(ofText text: String, with font: UIFont) {
        guard let range = (self.getAttributedText()?.string ?? self.getText())?.range(ofText: text) else { return }
        changeFont(inRange: range, with: font)
    }

    func changeFont(inRange range: NSRange, with font: UIFont) {
        add(attributes: [.font: font], inRange: range)
    }

    func changeTextColor(ofText text: String, with color: UIColor) {
        guard let range = (self.getAttributedText()?.string ?? self.getText())?.range(ofText: text) else { return }
        changeTextColor(inRange: range, with: color)
    }

    func changeTextColor(inRange range: NSRange, with color: UIColor) {
        add(attributes: [.foregroundColor: color], inRange: range)
    }

    private func add(attributes: [NSAttributedString.Key: Any], inRange range: NSRange) {
        guard !attributes.isEmpty else { return }

        var rangedAttributes: [RangedAttributes] = self.rangedAttributes

        var attributedString: NSMutableAttributedString

        if let attributedText = getAttributedText() {
            attributedString = NSMutableAttributedString(attributedString: attributedText)
        } else if let text = getText() {
            attributedString = NSMutableAttributedString(string: text)
        } else {
            return
        }

        rangedAttributes.append(RangedAttributes(attributes, inRange: range))
        
        rangedAttributes.forEach { (rangedAttributes) in
            attributedString.addAttributes(
                rangedAttributes.attributes,
                range: rangedAttributes.range
            )
        }

        set(attributedText: attributedString)
    }

    func resetFontChanges() {
        guard let text = getText() else { return }
        set(attributedText: NSMutableAttributedString(string: text))
    }
}
