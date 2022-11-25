//
//  UIImpactFeedbackGenerator+Extension.swift
//  CommonUI
//
//  Created by Chris Petimezas on 25/5/22.
//

import UIKit

extension UIImpactFeedbackGenerator {
    static func impact(_ style: FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
