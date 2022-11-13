//
//  TextFieldsHelper.swift
//  SharedKit
//
//  Created by Chris Petimezas on 13/11/22.
//

import UIKit

public class TextFieldsHelper {

    /// The EFUITextField array containing all the provided textfields.
    /// When set EFUITextFields, their returnKeyType property is changed according each index
    public var textFields: [UITextField] {
        get {
            return _textFields
        }
        set {
            self._textFields = setUp(textFields: newValue)
        }
    }

    private var _textFields: [UITextField] = []

    /// The initializer for this class
    /// - Parameter textFields: An array of EFUITextField.
    public init(textFields: [UITextField] = []) {
        self.textFields = textFields
    }

    /// A function to determine whether the provided EFUITextField should return
    /// - Parameter textField: EFUITextField
    /// - Returns: bool
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        guard let selectedIndex = textFields.firstIndex(of: textField) else {
            _ = textField.resignFirstResponder()
            return false
        }

        // Give Focus to the next available textfield (if exists)
        if selectedIndex + 1 < textFields.count {
            _ = textFields[selectedIndex + 1].becomeFirstResponder()
            return true
        }

        // Dismiss focus from selected textfield
        _ = textField.resignFirstResponder()

        return false
    }

    private func setUp(textFields: [UITextField]) -> [UITextField] {
        guard !textFields.isEmpty else { return [] }

        textFields.forEach({ $0.returnKeyType = .next })
        textFields.last?.returnKeyType = .done
        return textFields
    }

}
