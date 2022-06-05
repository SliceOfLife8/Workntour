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

    public func setupNavigationBar(mainTitle: String) {
        self.navigationController?.navigationBar.tintColor = UIColor.appColor(.lavender)
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = mainTitle

        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.appColor(.softBlack),
            .font: UIFont.scriptFont(.bold, size: 17)
        ]
        appearance.backgroundColor = UIColor.appColor(.extraLightGray)
        appearance.shadowImage = UIImage.pixelImageWithColor(color: UIColor.appColor(.separator))
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    public func showLoader() {
        let alert = UIAlertController(title: nil, message: "Please wait", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: false, completion: nil)
    }

}
