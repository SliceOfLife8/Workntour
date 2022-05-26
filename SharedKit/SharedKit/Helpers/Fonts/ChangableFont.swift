//
//  ChangableFont.swift
//  SharedKit
//
//  Created by Petimezas, Chris, Vodafone on 26/5/22.
//

import UIKit

public protocol ChangableFont: AnyObject {
    var rangedAttributes: [RangedAttributes] { get }
    func getText() -> String?
    func set(text: String?)
    func getAttributedText() -> NSAttributedString?
    func set(attributedText: NSAttributedString?)
    func getFont() -> UIFont?
    func changeFont(ofText text: String, with font: UIFont)
    func changeFont(inRange range: NSRange, with font: UIFont)
    func changeTextColor(ofText text: String, with color: UIColor)
    func changeTextColor(inRange range: NSRange, with color: UIColor)
    func resetFontChanges()
}

public struct RangedAttributes {

    public let attributes: [NSAttributedString.Key: Any]
    public let range: NSRange

    public init(_ attributes: [NSAttributedString.Key: Any], inRange range: NSRange) {
        self.attributes = attributes
        self.range = range
    }
}
