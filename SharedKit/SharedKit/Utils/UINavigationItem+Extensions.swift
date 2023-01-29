//
//  UINavigationItem+Extensions.swift
//  SharedKit
//
//  Created by Chris Petimezas on 22/1/23.
//

import UIKit

extension UINavigationItem {
    public func setTitle(title: String, subtitle: String) {

        let one = UILabel()
        one.text = title
        one.textColor = UIColor.appColor(.softBlack)
        one.font = UIFont.scriptFont(.bold, size: 17)
        one.sizeToFit()

        let two = UILabel()
        two.text = subtitle
        two.textColor = UIColor.appColor(.softBlack)
        two.font = UIFont.scriptFont(.italic, size: 12)
        two.textAlignment = .center
        two.sizeToFit()

        let stackView = UIStackView(arrangedSubviews: [one, two])
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.alignment = .center

        let width = max(one.frame.size.width, two.frame.size.width)
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 35)

        one.sizeToFit()
        two.sizeToFit()

        self.titleView = stackView
    }
}
