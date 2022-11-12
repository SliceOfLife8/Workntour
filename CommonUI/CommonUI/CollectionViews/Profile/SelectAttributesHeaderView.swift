//
//  SelectAttributesHeaderView.swift
//  CommonUI
//
//  Created by Chris Petimezas on 12/11/22.
//

import UIKit
import SharedKit

public class SelectAttributesHeaderView: UICollectionReusableView {

    public static let identifier = String(describing: SelectAttributesHeaderView.self)

    // MARK: - Outlets

    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var quantityLabel: UILabel!

    // MARK: - Methods

    public func configureLayout(for model: DataModel) {
        descriptionLabel.text = model.description
        titleLabel.text = model.title
        if model.currentQuantity < 3 {
            quantityLabel.text = "(\(model.currentQuantity)/\(model.minQuantity))"
            quantityLabel.textColor = .red
        }
        else {
            quantityLabel.text = "(\(model.currentQuantity)) ☑"
            quantityLabel.textColor = UIColor.appColor(.purpleBlack)
        }
    }
    
}

// MARK: - SelectAttributesHeaderView.DataModel
extension SelectAttributesHeaderView {

    public class DataModel {

        // MARK: - Properties

        let title: String
        let description: String
        let minQuantity: Int
        let currentQuantity: Int

        // MARK: - Constructors/Destructors

        public init(
            title: String,
            description: String,
            minQuantity: Int,
            currentQuantity: Int
        ) {
            self.title = title
            self.description = description
            self.minQuantity = minQuantity
            self.currentQuantity = currentQuantity
        }
    }
}
