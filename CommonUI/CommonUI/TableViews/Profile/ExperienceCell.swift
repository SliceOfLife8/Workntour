//
//  ExperienceCell.swift
//  CommonUI
//
//  Created by Chris Petimezas on 20/11/22.
//

import UIKit
import SharedKit

protocol ExperienceCellDelegate: AnyObject {
    func didTrashTap(_ cell: ExperienceCell)
}

class ExperienceCell: UITableViewCell {

    static let identifier = String(describing: ExperienceCell.self)

    weak var delegate: ExperienceCellDelegate?

    // MARK: - Outlets

    @IBOutlet weak var titleLabel: LinkableLabel!
    
    @IBOutlet weak var dateLabel: UILabel!

    // MARK: - Methods

    func configureLayout(for model: DataModel) {
        titleLabel.text = "\(model.organisation), \(model.position)"
        let highLightedPart = "\(model.organisation),"
        titleLabel.changeFont(
            ofText: highLightedPart,
            with: UIFont.scriptFont(.bold, size: 16)
        )
        titleLabel.changeTextColor(
            ofText: highLightedPart,
            with: UIColor.appColor(.lavender)
        )
        dateLabel.text = model.dates
    }

    // MARK: - Actions
    
    @IBAction func trashBtnTapped(_ sender: Any) {
        delegate?.didTrashTap(self)
    }
}

// MARK: - ExperienceCell.DataModel
extension ExperienceCell {

    class DataModel {

        // MARK: - Properties

        let organisation: String
        let position: String
        let dates: String

        // MARK: - Constructors/Destructors

        init(
            organisation: String,
            position: String,
            dates: String
        ) {
            self.organisation = organisation
            self.position = position
            self.dates = dates
        }

        // MARK: - Methods

        func sizeForItem(in contentView: UIView) -> CGSize {
            let width = contentView.bounds.width
            let topSpacing: CGFloat = 13

            let title = "\(organisation), \(position)"

            // 24 Leading, 8 spacing between label and trash, 24 -> arrow's width, 24 trailing
            let titleWidth = width - 24 - 8 - 24 - 16
            let titleHeight = title.calculatedHeight(
                onConstrainedWidth: titleWidth,
                fontName: .semibold,
                fontSize: 16,
                maxNumberOfLines: 0
            )

            let datesHeight = dates.calculatedHeight(
                onConstrainedWidth: titleWidth,
                fontName: .semibold,
                fontSize: 14,
                maxNumberOfLines: 1
            )

            let totalCellHeight = topSpacing
            + titleHeight
            + 4
            + datesHeight
            + 12

            return CGSize(width: width, height: totalCellHeight)
        }
    }
}
