//
//  AssetColor.swift
//  SharedKit
//
//  Created by Petimezas, Chris, Vodafone on 11/5/22.
//

import UIKit

/*
 If you want to use a new color asset, you should add here the name of the color & implement the color into main project 'Color.xcassets' folder.
 - Be careful: The name of color should be exactly the same both on enum & asset folder because we are using appColor extension static func.
 */

public enum AssetsColor: String {
    case primary // #af7eff
}

extension UIColor {
    public static func appColor(_ name: AssetsColor) -> UIColor {
        return UIColor(named: name.rawValue) ?? .black
    }
}
