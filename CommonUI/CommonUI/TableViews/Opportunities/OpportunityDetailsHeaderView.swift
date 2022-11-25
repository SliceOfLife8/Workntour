//
//  OpportunityDetailsHeaderView.swift
//  CommonUI
//
//  Created by Chris Petimezas on 5/7/22.
//

import UIKit

public class OpportunityDetailsHeaderView: UITableViewHeaderFooterView {

    public static let identifier = String(describing: OpportunityDetailsHeaderView.self)

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!

    public func configure(title: String?,
                          location: String?,
                          category: String?) {
        titleLabel.text = title
        locationLabel.text = location
        categoryLabel.text = category
    }

}
