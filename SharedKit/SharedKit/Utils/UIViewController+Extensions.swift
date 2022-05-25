//
//  UIViewController+Extensions.swift
//  SharedKit
//
//  Created by Petimezas, Chris, Vodafone on 25/5/22.
//

import UIKit

extension UIViewController {
    public func hideNavigationBar(_ animated: Bool){
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    public func showNavigationBar(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
