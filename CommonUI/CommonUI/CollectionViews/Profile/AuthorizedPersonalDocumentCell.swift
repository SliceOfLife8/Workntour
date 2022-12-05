//
//  AuthorizedPersonalDocumentCell.swift
//  CommonUI
//
//  Created by Chris Petimezas on 5/12/22.
//

import UIKit

public protocol AuthorizedPersonalDocumentCellDelegate: AnyObject {
    func uploadFileDidSelect()
}

public class AuthorizedPersonalDocumentCell: UICollectionViewCell {

    public static let identifier = String(describing: AuthorizedPersonalDocumentCell.self)

    public weak var delegate: AuthorizedPersonalDocumentCellDelegate?

    // MARK: - Outlets

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var apdView: UIView! {
        didSet {
            apdView.addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(addNewApdTapped(_:))
                )
            )
        }
    }

    @IBOutlet weak var mainStackView: UIStackView! {
        didSet {
            mainStackView.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
            mainStackView.isLayoutMarginsRelativeArrangement = true
        }
    }

    @IBOutlet weak var docNameLabel: UILabel!

    @IBOutlet weak var uploadedFileStackView: UIStackView! {
        didSet {
            uploadedFileStackView.layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
            uploadedFileStackView.isLayoutMarginsRelativeArrangement = true
        }
    }

    // MARK: - Methods

    public override func awakeFromNib() {
        super.awakeFromNib()
        apdView.layer.cornerRadius = 8
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        apdView.removeGradientLayers()
        apdView.setGradientLayer(borderWidth: 1)
    }

    public func configureLayout(for model: DataModel) {
        titleLabel.text = model.title
        if let docName = model.docName {
            apdView.isHidden = true
            uploadedFileStackView.isHidden = false
            mainStackView.backgroundColor = .white
            docNameLabel.text = docName
        }
        else {
            apdView.isHidden = false
            uploadedFileStackView.isHidden = true
        }
    }

    @IBAction func addNewApdTapped(_ sender: Any) {
        delegate?.uploadFileDidSelect()
    }
    
    @IBAction func trashActionTapped(_ sender: Any) {
        delegate?.uploadFileDidSelect()
    }
}

// MARK: - AuthorizedPersonalDocumentCell.DataModel
extension AuthorizedPersonalDocumentCell {

    public class DataModel {

        // MARK: - Properties

        let title: String
        let docName: String?

        // MARK: - Constructors/Destructors

        public init(title: String, docName: String?) {
            self.title = title
            self.docName = docName
        }

        // MARK: - Methods

        public func sizeForItem(in contentView: UIView) -> CGSize {
            let width = contentView.bounds.width
            let topSpacing: CGFloat = 16

            let titleWidth = width - 24*2
            let titleHeight = title.calculatedHeight(
                onConstrainedWidth: titleWidth,
                fontName: .semibold,
                fontSize: 16,
                maxNumberOfLines: 1
            )

            let uploadFileHeight: CGFloat = docName != nil ? 89 : 126

            let totalCellHeight = topSpacing
                + titleHeight
                + 16
                + uploadFileHeight
                + 4

            return CGSize(width: width, height: totalCellHeight)
        }
    }
}
