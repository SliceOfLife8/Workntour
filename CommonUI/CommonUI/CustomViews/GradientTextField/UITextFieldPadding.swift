//
//  UITextFieldPadding.swift
//  CommonUI
//
//  Created by Petimezas, Chris, Vodafone on 27/5/22.
//

import UIKit

// MARK: - TextFieldPadding
public class UITextFieldPadding: UITextField {

    var padding = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if let extraPadding = leftView?.bounds.width { // Add extra padding when leftView has been added
            padding.left = extraPadding + 8
        } else { // Reset
            padding.left = 14
        }
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        if let extraPadding = rightView?.bounds.width { // Add extra padding when rightView has been added
            padding.right = extraPadding
        } else { // Rest
            padding.right = 14
        }
        return bounds.inset(by: padding)
    }

}
