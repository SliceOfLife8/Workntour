//
//  UIFont+Extensions.swift
//  SharedKit
//
//  Created by Petimezas, Chris, Vodafone on 26/5/22.
//

import UIKit

public enum FontName {
    case black
    case blackItalic
    case bold
    case boldItalic
    case hairline
    case hairlineItalic
    case heavy
    case heavyItalic
    case italic
    case light
    case lightItalic
    case medium
    case mediumItalic
    case regular
    case semibold
    case semiboldItalic
    case thin
    case thinItalic

    var value: String {
        switch self {
        case .black:
            return "Lato-Black"
        case .blackItalic:
            return "Lato-BlackItalic"
        case .bold:
            return "Lato-Bold"
        case .boldItalic:
            return "Lato-BoldItalic"
        case .hairline:
            return "Lato-Hairline"
        case .hairlineItalic:
            return "Lato-HairlineItalic"
        case .heavy:
            return "Lato-Heavy"
        case .heavyItalic:
            return "Lato-HeavyItalic"
        case .italic:
            return "Lato-Italic"
        case .light:
            return "Lato-Light"
        case .lightItalic:
            return "Lato-LightItalic"
        case .medium:
            return "Lato-Medium"
        case .mediumItalic:
            return "Lato-MediumItalic"
        case .regular:
            return "Lato-Regular"
        case .semibold:
            return "Lato-Semibold"
        case .semiboldItalic:
            return "Lato-SemiboldItalic"
        case .thin:
            return "Lato-Thin"
        case .thinItalic:
            return "Lato-ThinItalic"
        }
    }
}

public extension UIFont {
    static func scriptFont(_ familyName: FontName, size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: familyName.value, size: size) else {
            assertionFailure("Something is messed up with custom font families! Please check it!")
            return UIFont.systemFont(ofSize: size)
        }
        return customFont
    }
}
