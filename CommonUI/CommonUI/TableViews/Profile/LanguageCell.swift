//
//  LanguageCell.swift
//  CommonUI
//
//  Created by Chris Petimezas on 20/11/22.
//

import UIKit
import SharedKit

protocol LanguageCellDelegate: AnyObject {
    func didTrashTap(_ cell: LanguageCell)
}

class LanguageCell: UITableViewCell {

    static let identifier = String(describing: LanguageCell.self)

    weak var delegate: LanguageCellDelegate?

    // MARK: - Outlets

    @IBOutlet weak var titleLabel: LinkableLabel! {
        didSet {
            titleLabel.isUserInteractionEnabled = false
        }
    }

    @IBOutlet weak var separatorView: UIView!

    // MARK: - Methods

    func configureLayout(for model: DataModel) {
        titleLabel.text = "\(model.language), \(model.level)"
        let highLightedPart = "\(model.language),"
        titleLabel.changeFont(
            ofText: highLightedPart,
            with: UIFont.scriptFont(.bold, size: 16)
        )
        titleLabel.changeTextColor(
            ofText: highLightedPart,
            with: UIColor.appColor(.lavender)
        )
        separatorView.isHidden = model.isLastItem
    }


    // MARK: - Actions

    @IBAction func trashTapped(_ sender: Any) {
        delegate?.didTrashTap(self)
    }
}

// MARK: - LanguageCell.DataModel
extension LanguageCell {

    class DataModel {
        
        // MARK: - Properties

        let language: String
        let level: String
        let isLastItem: Bool

        // MARK: - Constructors/Destructors

        init(
            language: String,
            level: String,
            isLastItem: Bool
        ) {
            self.language = language
            self.level = level
            self.isLastItem = isLastItem
        }
    }
}
