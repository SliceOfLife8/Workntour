//
//  ChipCell.swift
//  CommonUI
//
//  Created by Chris Petimezas on 12/11/22.
//

import UIKit

public class ChipCell: UICollectionViewCell {

    public static let identifier = String(describing: ChipCell.self)

    public override var isSelected: Bool {
        didSet {
            if isSelected {
                chipButton.setSelectedState()
            }
            else {
                chipButton.setDeselectedState()
            }
        }
    }

    // MARK: - Outlets

    @IBOutlet weak var chipButton: ChipButton! {
        didSet {
            chipButton.isEnabled = false
        }
    }

    // MARK: - Properties

    public var dataModel: DataModel?

    // MARK: - Methods

    public func configureLayout(for model: DataModel) {
        self.dataModel = model
        chipButton.setTitle(model.title, for: .normal)
    }

}

// MARK: - ChipCell.DataModel
extension ChipCell {

    public class DataModel {

        // MARK: - Properties

        public let title: String

        // MARK: - Constructors/Destructors

        public init(title: String) {
            self.title = title
        }
    }
}
