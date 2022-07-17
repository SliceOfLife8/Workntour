//
//  DynamicHeightCollectionView.swift
//  CommonUI
//
//  Created by Petimezas, Chris, Vodafone on 15/7/22.
//

import UIKit

public class DynamicHeightCollectionView: UICollectionView {
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }

    public override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
