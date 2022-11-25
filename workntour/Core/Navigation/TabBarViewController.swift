//
//  TabBarViewController.swift
//  workntour
//
//  Created by Chris Petimezas on 17/6/22.
//

import UIKit
import SharedKit

class TabBarViewController: UITabBarController {

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        // Draw Indicator above the tab bar items
        guard let numberOfTabs = tabBar.items?.count else {
            return
        }

        let numberOfTabsFloat = CGFloat(numberOfTabs)

        self.tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(
            color: UIColor.appColor(.lavender),
            size: CGSize(width: self.tabBar.frame.width/numberOfTabsFloat, height: self.tabBar.frame.height),
            lineThickness: 2.0,
            side: .top)
    }

}

private enum TabBarIndicatorSide: String {
    case top, left, right, bottom
}

private extension UIImage {
    func createSelectionIndicator(color: UIColor,
                                  size: CGSize,
                                  lineThickness: CGFloat,
                                  side: TabBarIndicatorSide) -> UIImage {
        var xPosition = 0.0
        var yPosition = 0.0
        var imgWidth = 2.0
        var imgHeight = 2.0
        switch side {
        case .top:
            xPosition = 0.0
            yPosition = 0.0
            imgWidth = size.width
            imgHeight = lineThickness
        case .bottom:
            xPosition = 0.0
            yPosition = size.height - lineThickness
            imgWidth = size.width
            imgHeight = lineThickness
        case .left:
            xPosition = 0.0
            yPosition = 0.0
            imgWidth = lineThickness
            imgHeight = size.height
        case .right:
            xPosition = size.width - lineThickness
            yPosition = 0.0
            imgWidth = lineThickness
            imgHeight = size.height
        }
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: xPosition, y: yPosition, width: imgWidth, height: imgHeight))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
