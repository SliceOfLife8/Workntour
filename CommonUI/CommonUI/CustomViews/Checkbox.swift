//
//  Checkbox.swift
//  CommonUI
//
//  Created by Petimezas, Chris, Vodafone on 27/5/22.
//

import UIKit

protocol CheckBoxDelegate: AnyObject {
    func didChange(isChecked: Bool)
}

public class Checkbox: UIButton {

    // MARK: - Vars
    let checkedImage = UIImage(named: "checkbox_on")
    let uncheckedImage = UIImage(named: "checkbox_off")
    weak var delegate: CheckBoxDelegate?

    public var isChecked: Bool = false {
        didSet {
            delegate?.didChange(isChecked: isChecked)
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }

    public override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        self.isChecked = false
        self.adjustsImageWhenHighlighted = false
    }

    @objc
    private func buttonClicked(sender: UIButton) {
        if sender == self {
            UIImpactFeedbackGenerator.impact(.light)
            sender.checkboxAnimation {
                self.isChecked = sender.isSelected
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
