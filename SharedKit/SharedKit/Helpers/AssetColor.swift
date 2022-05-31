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
    case primary // #FAF8FE
    case lavender // #8870F9
    case lavender2 // #4242A4
    case purple // #7E6FD8
    case mint // #0EE5D0
    case extraLightGray // #F9F9F9
    case softBlack // #333333
    case separator // #F9F9F9
    case placeholder // #918DA9
    case basicText // #29282D
    case lightGray // #F6F6F6
    case deepPurple // #431879
}

extension UIColor {
    public static func appColor(_ name: AssetsColor) -> UIColor {
        return UIColor(named: name.rawValue) ?? .black
    }
}
