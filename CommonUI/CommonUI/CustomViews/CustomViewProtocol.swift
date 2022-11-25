//
//  CustomViewProtocol.swift
//  CommonUI
//
//  Created by Chris Petimezas on 2/6/22.
//

import UIKit

protocol CustomViewProtocol {

    /// The content of the view
    var contentView: UIView! { get }

    /// Attach a custom `Nib` to the view's content.
    /// - Parameter customClass: the class of the `Nib` to attach.
    func commonInit(for customClass: AnyClass)
}

extension CustomViewProtocol where Self: UIView {

    func commonInit(for customClass: AnyClass) {
        let bundle = Bundle(for: customClass.self)
        bundle.loadNibNamed(String(describing: customClass.self), owner: self)
        addSubview(contentView)
        contentView.backgroundColor = .clear
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

}
