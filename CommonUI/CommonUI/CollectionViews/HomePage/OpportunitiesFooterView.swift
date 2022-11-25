//
//  OpportunitiesFooterView.swift
//  CommonUI
//
//  Created by Chris Petimezas on 14/7/22.
//

import UIKit
import NVActivityIndicatorView

public class OpportunitiesFooterView: UICollectionReusableView {

    public static let identifier = String(describing: OpportunitiesFooterView.self)

    @IBOutlet weak var loader: NVActivityIndicatorView!

    override public func awakeFromNib() {
        super.awakeFromNib()

        loader.startAnimating()
    }
}
