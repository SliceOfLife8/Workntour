//
//  OpportunityDetailsCell.swift
//  CommonUI
//
//  Created by Chris Petimezas on 5/7/22.
//

import UIKit

public class OpportunityDetailsCell: UITableViewCell {

    public static let identifier = String(describing: OpportunityDetailsCell.self)

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    public override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text?.removeAll()
        descriptionLabel.text?.removeAll()
    }

    public func setup(title: String?,
                      value: String?) {
        titleLabel.text = title
        descriptionLabel.text = (value?.isEmpty == true) ? "Not provided" : value
    }
    
}
