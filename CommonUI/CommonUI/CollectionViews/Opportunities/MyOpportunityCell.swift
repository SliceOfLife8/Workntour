//
//  MyOpportunityCell.swift
//  CommonUI
//
//  Created by Petimezas, Chris, Vodafone on 26/6/22.
//

import UIKit
import Kingfisher

public class MyOpportunityCell: UICollectionViewCell {

    public static let identifier = String(describing: MyOpportunityCell.self)

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!

    public override var isHighlighted: Bool {
        didSet {
            onHighlightChanged()
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
    }

    public func configure(_ imageUrl: URL?,
                          jobTitle: String,
                          location: String,
                          category: String,
                          dates: [(start: String, end: String)]) {
        imageView.kf.setImage(with: imageUrl)
        jobTitleLabel.text = jobTitle
        locationLabel.text = location
        categoryLabel.text = category
        // Setup Dates
        var datesText: String = ""
        let remainingDates = dates.dropFirst(2).count

        for (index, element) in dates.prefix(2).enumerated() {
            let startDate = element.start.opportunityDateFormat()
            let endDate = element.end.opportunityDateFormat()

            datesText += (index == 0) ? "\(startDate) - \(endDate)" : ", \(startDate) - \(endDate)"
        }

        datesLabel.text = (remainingDates > 0) ? "\(datesText) (+\(remainingDates) more)" : datesText
    }

    private func onHighlightChanged() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.contentView.alpha = self.isHighlighted ? 0.9 : 1.0
            self.contentView.transform = self.isHighlighted ?
            CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95) :
            CGAffineTransform.identity
        })
    }

}
