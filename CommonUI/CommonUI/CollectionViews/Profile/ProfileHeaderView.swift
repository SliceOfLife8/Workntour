//
//  ProfileHeaderView.swift
//  CommonUI
//
//  Created by Chris Petimezas on 18/11/22.
//

import UIKit
import KDCircularProgress
import SharedKit
import Kingfisher

public protocol ProfileHeaderViewDelegate: AnyObject {
    func showImagePicker()
}

public class ProfileHeaderView: UICollectionReusableView {

    public static let identifier = String(describing: ProfileHeaderView.self)

    // MARK: - Outlets

    @IBOutlet weak var progressBar: KDCircularProgress!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var percentageButton: GradientButton!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var introLabel: LinkableLabel!
    @IBOutlet weak var typeButton: UIButton!

    // MARK: - Properties

    var dataModel: DataModel?
    public weak var delegate: ProfileHeaderViewDelegate?

    // MARK: - Methods

    public override func layoutSubviews() {
        super.layoutSubviews()

        typeButton.layer.cornerRadius = 12
        introLabel.setLineHeight(lineHeight: 1.33)
    }

    public func configureLayout(for model: DataModel) {
        self.dataModel = model
        fullnameLabel.text = model.fullname
        introLabel.text = model.introText
        progressBar.isHidden = false
        typeButton.setTitle(
            model.mode.value,
            for: .normal
        )
        imageView.kf.setImage(
            with: model.profileUrl,
            placeholder: UIImage(named: model.mode.placeholder,
                                 in: Bundle(for: type(of: self)),
                                 with: nil)
        )
    }

    public func startAnimation() {
        guard let dataModel else { return }
        percentageButton.setTitle("", for: .normal)
        percentageButton.isHidden = true
        progressBar.animate(fromAngle: 0,
                                 toAngle: dataModel.percent360,
                                 duration: dataModel.duration,
                                 completion: { _ in
            self.percentageButton.setTitle("\(dataModel.percent100)% Complete", for: .normal)
            self.percentageButton.isHidden.toggle()
        })
    }

    public func updateImage(_ data: Data) {
        imageView.image = UIImage(data: data)
    }

    // MARK: - Actions
    
    @IBAction func addNewImage(_ sender: Any) {
        self.delegate?.showImagePicker()
    }
}

// MARK: - ProfileHeaderView.DataModel
extension ProfileHeaderView {

    public class DataModel {

        public enum Mode {
            case traveler
            case company
            case individual

            var placeholder: String {
                switch self {
                case .traveler:
                    return "traveler"
                case .company, .individual:
                    return "host"
                }
            }

            var value: String {
                switch self {
                case .traveler:
                    return "Traveler"
                case .company:
                    return "Company"
                case .individual:
                    return "Individual"
                }
            }
        }

        // MARK: - Properties

        let mode: Mode
        let profileUrl: URL?
        let fullname: String
        let introText: String
        let percent360: Double
        let percent100: Int
        let duration: Double

        // MARK: - Constructors/Destructors

        public init(
            mode: Mode,
            profileUrl: URL?,
            fullname: String,
            introText: String,
            percent360: Double,
            percent100: Int,
            duration: Double
        ) {
            self.mode = mode
            self.profileUrl = profileUrl
            self.fullname = fullname
            self.introText = introText
            self.percent360 = percent360
            self.percent100 = percent100
            self.duration = duration
        }

        // MARK: - Methods

        public func sizeForItem(in contentView: UIView) -> CGSize {
            let width = contentView.bounds.width
            let topSpacing: CGFloat = 8
            let circularViewHeight: CGFloat = 240

            let fullNameWidth = width - 48*2
            let fullNameHeight = fullname.calculatedHeight(
                onConstrainedWidth: fullNameWidth,
                fontName: .bold,
                fontSize: 36,
                maxNumberOfLines: 0
            )

            let introWidth = width - 24*2
            let introHeight = introText.calculatedHeight(
                onConstrainedWidth: introWidth,
                fontName: .regular,
                fontSize: 16,
                maxNumberOfLines: 0
            )

            let typeButtonHeight: CGFloat = 25

            let totalCellHeight = topSpacing
                + circularViewHeight
                + 8
                + fullNameHeight
                + 16
                + typeButtonHeight
                + 24
                + introHeight
                + 16

            return CGSize(width: width, height: totalCellHeight)
        }
    }
}
