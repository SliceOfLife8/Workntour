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

    public func setupNavigationBar(mainTitle: String?) {
        self.navigationController?.navigationBar.tintColor = UIColor.appColor(.lavender)
        self.navigationController?.navigationBar.topItem?.title = ""

        self.navigationController?.navigationBar.barTintColor = UIColor.appColor(.lightGray)
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.appColor(.softBlack),
            .font: UIFont.scriptFont(.bold, size: 17)
        ]

        self.navigationItem.title = mainTitle

        let appearance = UINavigationBarAppearance()
        appearance.shadowImage = UIImage.pixelImageWithColor(color: UIColor.appColor(.separator))
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

    }

    public func setupNavigationBar(withLargeTitle: String?) {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.scriptFont(.bold, size: 17)
        ]

        self.navigationItem.title = withLargeTitle
    }

}
