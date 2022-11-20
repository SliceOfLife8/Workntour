//
//  ProfileLanguageCell.swift
//  CommonUI
//
//  Created by Chris Petimezas on 19/11/22.
//

import UIKit

public protocol ProfileLanguageCellDelegate: AnyObject {
    func addNewLanguage()
    func editLanguage(at index: Int)
    func deleteLanguage(at index: Int)
}

public class ProfileLanguageCell: UICollectionViewCell {

    public static let identifier = String(describing: ProfileLanguageCell.self)

    // MARK: - Outlets

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var descriptionStackView: UIStackView! {
        didSet {
            descriptionStackView.layoutMargins = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 16)
            descriptionStackView.isLayoutMarginsRelativeArrangement = true
            descriptionStackView.addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(descriptionAreaTapped)
                )
            )
        }
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(
                UINib(nibName: LanguageCell.identifier,
                      bundle: Bundle(for: LanguageCell.self)),
                forCellReuseIdentifier: LanguageCell.identifier
            )
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Properties

    var dataModel: DataModel?

    public weak var delegate: ProfileLanguageCellDelegate?

    // MARK: - Methods

    public func configureLayout(for model: DataModel) {
        self.dataModel = model
        titleLabel.text = model.title
        descriptionLabel.text = model.description

        if model.languages.isEmpty {
            descriptionStackView.isHidden = false
            tableView.isHidden = true
        }
        else {
            tableView.isHidden = false
            descriptionStackView.isHidden = true
            tableViewHeightConstraint.constant = 48 * CGFloat(model.languages.count)
        }
    }

    // MARK: - Actions

    @IBAction func addNewLangBtnTapped(_ sender: Any) {
        delegate?.addNewLanguage()
    }

    @objc
    private func descriptionAreaTapped() {
        delegate?.addNewLanguage()
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProfileLanguageCell: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel?.languages.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections - 1)
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LanguageCell.identifier,
            for: indexPath
        ) as? LanguageCell,
              let profileLanguage = dataModel?.languages[indexPath.row]
        else {
            return UITableViewCell()
        }

        cell.configureLayout(
            for: .init(
                language: profileLanguage.language,
                level: profileLanguage.proficiency,
                isLastItem: indexPath.row == lastRowIndex - 1
            )
        )
        cell.delegate = self

        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.editLanguage(at: indexPath.row)
    }
}

extension ProfileLanguageCell: LanguageCellDelegate {

    func didTrashTap(_ cell: LanguageCell) {
        guard let row = tableView.indexPath(for: cell)?.row else { return }
        delegate?.deleteLanguage(at: row)
    }
}

// MARK: - ProfileLanguageCell.DataModel
extension ProfileLanguageCell {

    public class DataModel {

        public struct ProfileLanguageUI {
            let language: String
            let proficiency: String

            public init(language: String, proficiency: String) {
                self.language = language
                self.proficiency = proficiency
            }
        }

        // MARK: - Properties

        let title: String
        let description: String
        let languages: [ProfileLanguageUI]

        // MARK: - Constructors/Destructors

        public init(
            title: String,
            description: String,
            languages: [ProfileLanguageUI]
        ) {
            self.title = title
            self.description = description
            self.languages = languages
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

            // 24 Leading, 8 spacing between label and arrow, 24 -> arrow's width, 16 trailing
            let descriptionLabel = width - 24 - 8 - 24 - 16
            let descriptionHeight = description.calculatedHeight(
                onConstrainedWidth: descriptionLabel,
                fontName: .regular,
                fontSize: 16,
                maxNumberOfLines: 0
            )

            let totalCellHeight: CGFloat

            let numOfLanguages = languages.count
            if numOfLanguages > 0 {
                totalCellHeight = topSpacing
                    + titleHeight
                    + 16*2
                    + CGFloat(numOfLanguages)*48
            }
            else {
                totalCellHeight = topSpacing
                    + titleHeight
                    + 16*2
                    + descriptionHeight
                    + 20
            }

            return CGSize(width: width, height: totalCellHeight)
        }
    }
}
