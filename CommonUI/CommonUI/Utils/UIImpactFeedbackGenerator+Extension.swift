//
//  UIImpactFeedbackGenerator+Extension.swift
//  CommonUI
//
//  Created by Petimezas, Chris, Vodafone on 25/5/22.
//

import UIKit

extension UIImpactFeedbackGenerator {
    static func impact(_ style: FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
