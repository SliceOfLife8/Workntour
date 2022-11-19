//
//  ProfileSimpleCell.swift
//  CommonUI
//
//  Created by Chris Petimezas on 18/11/22.
//

import UIKit
import SharedKit

public protocol ProfileSimpleCellDelegate: AnyObject {
    func contentViewDidSelect(_ cell: ProfileSimpleCell)
}

public class ProfileSimpleCell: UICollectionViewCell {

    // MARK: - Properties

    public static let identifier = String(describing: ProfileSimpleCell.self)

    public weak var delegate: ProfileSimpleCellDelegate?

    // MARK: - Outlets

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var descriptionContainerView: UIView! {
        didSet {
            descriptionContainerView.addGestureRecognizer(UITapGestureRecognizer(
                target: self,
                action: #selector(contentViewTapped)
            ))
        }
    }

    // MARK: - Methods

    public func configureLayout(for model: DataModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        descriptionLabel.textColor = model.textColor
    }

    @objc
    private func contentViewTapped() {
        delegate?.contentViewDidSelect(self)
    }

}

// MARK: - ProfileSimpleCell.DataModel
extension ProfileSimpleCell {

    public class DataModel {

        // MARK: - Properties

        var title: String
        let description: String
        let textColor: UIColor?

        // MARK: - Constructors/Destructors

        public init(
            title: String,
            values: [String?],
            placeholder: String
        ) {
            self.title = title
            let _values = values.compactMap { $0 }
            // Check if array isEmpty or it contains empty items
            if _values.isEmpty || _values.map({ $0.isEmpty }).contains(true) {
                self.description = placeholder
                self.textColor = UIColor.appColor(.placeholder)
            }
            else {
                self.description = _values.joined(separator: " ")
                self.textColor = UIColor.appColor(.floatingLabel)
            }
        }

        // MARK: - Methods

        public func sizeForItem(in contentView: UIView) -> CGSize {
            let width = contentView.bounds.width
            let topSpacing: CGFloat = 16

            let titleWidth = width - 24*2
            let titleHeight = title.calculatedHeight(
                onConstrainedWidth: titleWidth,
                fontName: .semibold,
                fontSize: 16,
                maxNumberOfLines: 1
            )

            // 24 Leading, 32 spacing between label and arrow, 24 -> arrow's width, 16 trailing
            let descriptionLabel = width - 24 - 32 - 24 - 16
            let descriptionHeight = description.calculatedHeight(
                onConstrainedWidth: descriptionLabel,
                fontName: .regular,
                fontSize: 16,
                maxNumberOfLines: 0
            )

            let totalCellHeight = topSpacing
                + titleHeight
                + 16*2
                + descriptionHeight
                + 16

            return CGSize(width: width, height: totalCellHeight)
        }
    }
}
