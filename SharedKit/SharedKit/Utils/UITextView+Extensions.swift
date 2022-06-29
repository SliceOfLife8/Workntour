//
//  UITextView+Extensions.swift
//  SharedKit
//
//  Created by Petimezas, Chris, Vodafone on 28/6/22.
//

import UIKit

public extension UITextView {

    private class PlaceholderLabel: UILabel { }

    private var placeholderLabel: PlaceholderLabel {
        if let label = subviews.compactMap({ $0 as? PlaceholderLabel }).first {
            return label
        } else {
            let label = PlaceholderLabel(frame: .zero)
            label.font = UIFont.scriptFont(.regular, size: 12)
            label.textColor = UIColor.appColor(.placeholder)
            addSubview(label)
            return label
        }
    }

    @IBInspectable
    var placeholder: String {
        get {
            return subviews.compactMap({ $0 as? PlaceholderLabel }).first?.text ?? ""
        }
        set {
            self.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            self.layer.cornerRadius = 8
            self.tintColor = .purple
            let placeholderLabel = self.placeholderLabel
            placeholderLabel.text = newValue
            placeholderLabel.numberOfLines = 0
            let width = frame.width - textContainer.lineFragmentPadding * 2 - 16
            let size = placeholderLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
            placeholderLabel.frame.size.height = size.height
            placeholderLabel.frame.size.width = width
            placeholderLabel.frame.origin = CGPoint(x: textContainer.lineFragmentPadding + textContainerInset.left, y: textContainerInset.top)

            textStorage.delegate = self
        }
    }

}

extension UITextView: NSTextStorageDelegate {
    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
}
