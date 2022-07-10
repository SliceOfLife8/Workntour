//
//  OpportunityDetailsDatesCell.swift
//  CommonUI
//
//  Created by Petimezas, Chris, Vodafone on 6/7/22.
//

import UIKit

public class OpportunityDetailsDatesCell: UITableViewCell {
    public static let identifier = String(describing: OpportunityDetailsDatesCell.self)

    // MARK: - Outlets
    @IBOutlet weak var topTitleOne: UILabel!
    @IBOutlet weak var topTitleTwo: UILabel!
    @IBOutlet weak var descriptionOne: UILabel!
    @IBOutlet weak var descriptionTwo: UILabel!

    public func setup(leftHeader: String?,
                      rightHeader: String?,
                      title: String?,
                      value: String?,
                      showDays: Bool = false) {

        topTitleOne.text = leftHeader
        topTitleTwo.text = rightHeader

        if let minDays = title, let maxDays = value, showDays {
            descriptionOne.text = "\(minDays) days"
            descriptionTwo.text = "\(maxDays) days"
        } else {
            descriptionOne.text = title?.opportunityDateFormat()
            descriptionTwo.text = value?.opportunityDateFormat()
        }
    }

}
