//
//  TransparentButton.swift
//  CommonUI
//
//  Created by Chris Petimezas on 11/7/22.
//

import UIKit

public class TransparentButton: UIButton {
    
    override public var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.5 : 1.0
        }
    }

}
