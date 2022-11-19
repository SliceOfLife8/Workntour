//
//  ProfileFooterView.swift
//  CommonUI
//
//  Created by Chris Petimezas on 19/11/22.
//

import UIKit

public protocol ProfileFooterViewDelegate: AnyObject {
    func dietaryHasChanged(at index: Int)
    func driverLicenseHasChanged(_ hasLicense: Bool)
}

public class ProfileFooterView: UICollectionReusableView {

    public static let identifier = String(describing: ProfileFooterView.self)
    public weak var delegate: ProfileFooterViewDelegate?

    // MARK: - Outlets

    @IBOutlet weak var dietaryLabel: UILabel!
    @IBOutlet weak var dietarySegmentedControl: UISegmentedControl!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var licenseSegmentedControl: UISegmentedControl!

    public func configureLayout(for model: DataModel) {
        dietaryLabel.text = model.dietaryTitle
        licenseLabel.text = model.licenseTitle
        dietarySegmentedControl.selectedSegmentIndex = model.dietarySelection
        licenseSegmentedControl.selectedSegmentIndex = model.hasLicense ? 0 : 1
    }

    // MARK: - Actions

    @IBAction func dietaryValueHasChanged(_ sender: UISegmentedControl) {
        self.delegate?.dietaryHasChanged(at: sender.selectedSegmentIndex)
    }

    @IBAction func licenseValueHasChanged(_ sender: UISegmentedControl) {
        self.delegate?.driverLicenseHasChanged(sender.selectedSegmentIndex == 0)
    }
}

// MARK: - ProfileFooterView.DataModel
extension ProfileFooterView {

    public class DataModel {

        // MARK: - Properties

        let dietaryTitle: String
        let dietarySelection: Int
        let licenseTitle: String
        let hasLicense: Bool

        // MARK: - Constuctors/Destructors

        public init(
            dietaryTitle: String,
            dietarySelection: Int,
            licenseTitle: String,
            hasLicense: Bool
        ) {
            self.dietaryTitle = dietaryTitle
            self.dietarySelection = dietarySelection
            self.licenseTitle = licenseTitle
            self.hasLicense = hasLicense
        }

        // MARK: - Methods

        public func sizeForItem(in contentView: UIView) -> CGSize {
            let width = contentView.bounds.width
            let topSpacing: CGFloat = 24

            let dietaryWidth = width - 24*2
            let dietaryHeight = dietaryTitle.calculatedHeight(
                onConstrainedWidth: dietaryWidth,
                fontName: .medium,
                fontSize: 14,
                maxNumberOfLines: 1
            )

            let licenseWidth = width - 24*2
            let licenseHeight = licenseTitle.calculatedHeight(
                onConstrainedWidth: licenseWidth,
                fontName: .medium,
                fontSize: 14,
                maxNumberOfLines: 1
            )

            let segmentedControlHeight: CGFloat = 32
            let spacesBetweenItemsInStackview: CGFloat = 16*4

            let totalCellHeight = topSpacing
                + dietaryHeight
                + segmentedControlHeight
                + licenseHeight
                + segmentedControlHeight
                + spacesBetweenItemsInStackview

            return CGSize(width: width, height: totalCellHeight)
        }
    }
}
