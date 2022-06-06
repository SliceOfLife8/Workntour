//
//  AlertHelper.swift
//  SharedKit
//
//  Created by Petimezas, Chris, Vodafone on 26/5/22.
//

import Foundation
import UIKit

public class AlertHelper {

    public static func showAlertWithTwoActions(_ controller: UIViewController, title: String, message: String? = nil, leftButtonTitle: String, rightButtonTitle: String, leftAction: @escaping ()-> Void, rightAction: @escaping ()-> Void) {

        let attributedString = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: UIFont.scriptFont(.bold, size: 17),
            NSAttributedString.Key.foregroundColor: UIColor.appColor(.lavender)
        ])

        let dialog = UIAlertController(title: "", message: message, preferredStyle: .alert)
        dialog.setValue(attributedString, forKey: "attributedTitle")

        dialog.addAction(UIAlertAction(title: leftButtonTitle, style: .default, handler: { _ in
            leftAction()
        }))
        dialog.addAction(UIAlertAction(title: rightButtonTitle, style: .default, handler: { _ in
            rightAction()
        }))

        dialog.view.tintColor = UIColor.appColor(.lavender2)

        controller.present(dialog, animated: true, completion: nil)
    }

    public static func showDefaultAlert(_ controller: UIViewController, title: String, message: String? = nil) {
        let attributedString = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: UIFont.scriptFont(.bold, size: 17),
            NSAttributedString.Key.foregroundColor: UIColor.appColor(.lavender)
        ])

        let dialog = UIAlertController(title: "", message: message, preferredStyle: .alert)
        dialog.setValue(attributedString, forKey: "attributedTitle")

        dialog.addAction(UIAlertAction(title: "OK", style: .default))
        
        dialog.view.tintColor = UIColor.appColor(.lavender2)

        controller.present(dialog, animated: true, completion: nil)
    }

}
