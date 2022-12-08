//
//  OnboardingCell.swift
//  CommonUI
//
//  Created by Chris Petimezas on 7/12/22.
//

import UIKit

public class OnboardingCell: UICollectionViewCell {

    public static let identifier = String(describing: OnboardingCell.self)

    // MARK: - Outlets

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel!

    // MARK: - Methods

    public func configureLayout(for model: DataModel) {
        imageView.image = UIImage(named: model.image,
                                  in: Bundle(for: type(of: self)),
                                  with: nil)
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }
}

// MARK: - OnboardingCell.DataModel
extension OnboardingCell {

    public class DataModel {

        public enum Mode {
            case pageOne
            case pageTwo
            case pageThree

            var image: String {
                switch self {
                case .pageOne:
                    return "onboarding_one"
                case .pageTwo:
                    return "onboarding_two"
                case .pageThree:
                    return "onboarding_three"
                }
            }
        }

        // MARK: - Properties

        let image: String
        let title: String
        let description: String

        // MARK: - Constructors/Destructors

        public init(mode: Mode, title: String, description: String) {
            self.image = mode.image
            self.title = title
            self.description = description
        }
    }
}
