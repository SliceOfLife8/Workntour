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

        self.navigationItem.title = mainTitle

        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = UIColor.appColor(.separator)
        appearance.backgroundColor = UIColor.appColor(.lightGray)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.appColor(.softBlack),
            .font: UIFont.scriptFont(.bold, size: 17)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.appColor(.softBlack)
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    public func setupNavigationBar(withLargeTitle: String?) {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.navigationItem.title = withLargeTitle
    }

    public func setupBlurNavigationBar() {
        self.navigationController?.navigationBar.tintColor = UIColor.appColor(.lavender)
        self.navigationController?.navigationBar.topItem?.title = ""
        let bounds = self.navigationController?.navigationBar.bounds
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = bounds ?? CGRect.zero
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.navigationController?.navigationBar.sendSubviewToBack(visualEffectView)
    }

}
