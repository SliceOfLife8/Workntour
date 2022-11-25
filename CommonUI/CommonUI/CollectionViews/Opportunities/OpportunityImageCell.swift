//
//  OpportunityImageCell.swift
//  CommonUI
//
//  Created by Chris Petimezas on 28/6/22.
//

import UIKit

public protocol OpportunityImageCellDelegate: AnyObject {
    func removeImage(_ cell: OpportunityImageCell)
}

public class OpportunityImageCell: UICollectionViewCell {
    public static let identifier = String(describing: OpportunityImageCell.self)
    public weak var delegate: OpportunityImageCellDelegate?

    public override var isHighlighted: Bool {
        didSet {
            onHighlightChanged()
        }
    }

    @IBOutlet public weak var imageView: UIImageView!

    public override func awakeFromNib() {
        super.awakeFromNib()

        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }

    private func onHighlightChanged() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.imageView?.alpha = self.isHighlighted ? 0.9 : 1.0
            self.imageView?.transform = self.isHighlighted ?
            CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95) :
            CGAffineTransform.identity
        })
    }

    @IBAction func removeBtnTapped(_ sender: Any) {
        delegate?.removeImage(self)
    }
}
