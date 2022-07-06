//
//  OpportunityDetailsCell.swift
//  CommonUI
//
//  Created by Petimezas, Chris, Vodafone on 5/7/22.
//

import UIKit

public class OpportunityDetailsCell: UITableViewCell {

    public static let identifier = String(describing: OpportunityDetailsCell.self)

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var datesStackView: UIStackView!
    @IBOutlet weak var minimumDays: UILabel!
    @IBOutlet weak var maximumDays: UILabel!

    public func setup(title: String?,
                      value: String?,
                      showDays: Bool) {
        titleLabel.text = title
        descriptionLabel.text = value

        if let minDays = title, let maxDays = value, showDays {
            datesStackView.isHidden = false
            mainStackView.isHidden = true
            minimumDays.text = "\(minDays) days"
            maximumDays.text = "\(maxDays) days"
        }
    }
    
}
