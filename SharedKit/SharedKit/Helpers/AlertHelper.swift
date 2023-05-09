//
//  AlertHelper.swift
//  SharedKit
//
//  Created by Chris Petimezas on 26/5/22.
//

import Foundation
import UIKit

public class AlertHelper {

    public static func showAlertWithTwoActions(
        _ controller: UIViewController,
        title: String,
        message: String? = nil,
        hasCancelOption: Bool = false,
        leftButtonTitle: String,
        leftButtonStyle: UIAlertAction.Style = .default,
        rightButtonTitle: String,
        rightButtonStyle: UIAlertAction.Style = .default,
        leftAction: @escaping ()-> Void,
        rightAction: @escaping ()-> Void
    ) {

        let attributedString = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: UIFont.scriptFont(.bold, size: 17),
            NSAttributedString.Key.foregroundColor: UIColor.appColor(.lavender)
        ])

        let dialog = UIAlertController(title: "", message: message, preferredStyle: .alert)
        dialog.setValue(attributedString, forKey: "attributedTitle")

        dialog.addAction(UIAlertAction(title: leftButtonTitle, style: leftButtonStyle, handler: { _ in
            leftAction()
        }))
        dialog.addAction(UIAlertAction(title: rightButtonTitle, style: rightButtonStyle, handler: { _ in
            rightAction()
        }))
        if hasCancelOption {
            dialog.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel))
        }

        dialog.view.tintColor = UIColor.appColor(.lavender2)

        controller.present(dialog, animated: true, completion: nil)
    }

    public static func showDefaultAlert(
        _ controller: UIViewController,
        title: String,
        message: String? = nil,
        dismissCompletion: @escaping ()-> Void = {}
    ) {
        let attributedString = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: UIFont.scriptFont(.bold, size: 17),
            NSAttributedString.Key.foregroundColor: UIColor.appColor(.lavender)
        ])

        let dialog = UIAlertController(title: "", message: message, preferredStyle: .alert)
        dialog.setValue(attributedString, forKey: "attributedTitle")

        dialog.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: { _ in
                    dismissCompletion()
                }
            )
        )

        dialog.view.tintColor = UIColor.appColor(.lavender2)

        controller.present(dialog, animated: true, completion: nil)
    }

}
