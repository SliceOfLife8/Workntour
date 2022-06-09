//
//  Checkbox.swift
//  CommonUI
//
//  Created by Petimezas, Chris, Vodafone on 27/5/22.
//

import UIKit

public protocol CheckBoxDelegate: AnyObject {
    func didChange(isChecked: Bool, box: Checkbox)
}

public class Checkbox: UIButton {

    public weak var delegate: CheckBoxDelegate?

    // MARK: - Vars
    @IBInspectable public var checkedImage: UIImage? = UIImage(named: "checkbox_on") {
        didSet {
            self.setImage(checkedImage, for: .normal)
        }
    }
    @IBInspectable public var uncheckedImage: UIImage? = UIImage(named: "checkbox_off") {
        didSet {
            self.setImage(uncheckedImage, for: .normal)
        }
    }

    @IBInspectable
    public var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }

    public override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        self.adjustsImageWhenHighlighted = false
    }

    @objc
    private func buttonClicked(sender: UIButton) {
        if sender == self {
            UIImpactFeedbackGenerator.impact(.light)
            sender.checkboxAnimation {
                self.isChecked.toggle()
                self.delegate?.didChange(isChecked: self.isChecked, box: self)
            }
        }
    }
}

private extension UIButton {
    // MARK: - Animate check mark
    func checkboxAnimation(closure: @escaping () -> Void) {
        guard let image = self.imageView else { return }

        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { (_) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.isSelected.toggle()
                image.transform = .identity
            }, completion: { _ in
                closure()
            })
        })
    }
}
