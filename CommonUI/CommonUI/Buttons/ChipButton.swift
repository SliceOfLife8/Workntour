//
//  ChipButton.swift
//  CommonUI
//
//  Created by Chris Petimezas on 12/11/22.
//

import UIKit
import SharedKit

public class ChipButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    private func setUp() {
        sizeToFit()
        layer.cornerRadius = 12
        clipsToBounds = true
        titleLabel?.lineBreakMode = .byClipping 
        contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        setDeselectedState()
    }

    public func setSelectedState() {
        backgroundColor = UIColor(hexString: "#8870F9")
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.scriptFont(.bold, size: 12)
    }

    public func setDeselectedState() {
        backgroundColor = UIColor(hexString: "#EDEAFF")
        setTitleColor(UIColor(hexString: "#554DB8"), for: .normal)
        titleLabel?.font = UIFont.scriptFont(.semibold, size: 12)
        sizeToFit()
    }

    public override var isHighlighted: Bool {
        didSet {
            let xScale: CGFloat = isHighlighted ? 0.975 : 1.0
            let yScale: CGFloat = isHighlighted ? 0.95 : 1.0
            UIView.animate(withDuration: 0.1) {
                let transformation = CGAffineTransform(scaleX: xScale, y: yScale)
                self.transform = transformation
            }
        }
    }

}
