//
//  ProfileExperienceCell.swift
//  CommonUI
//
//  Created by Chris Petimezas on 20/11/22.
//

import UIKit
import SharedKit

public protocol ProfileExperienceCellDelegate: AnyObject {
    func addNewExperience()
    func editExperience(withUUID uuid: String)
    func deleteExperience(withUUID uuid: String)
}

public class ProfileExperienceCell: UICollectionViewCell {
    
    public static let identifier = String(describing: ProfileExperienceCell.self)

    // MARK: - Outlets

    @IBOutlet weak var titleLabel: UILabel!

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

    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(
                UINib(nibName: ExperienceCell.identifier,
                      bundle: Bundle(for: ExperienceCell.self)),
                forCellReuseIdentifier: ExperienceCell.identifier
            )
            tableView.backgroundColor = .white
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Properties

    var dataModel: DataModel?

    public weak var delegate: ProfileExperienceCellDelegate?

    // MARK: - Methods

    public func configureLayout(for model: DataModel) {
        self.dataModel = model
        titleLabel.text = model.title
        descriptionLabel.text = model.description

        let tableViewHeight = model.tableViewHeight(in: contentView)

        if tableViewHeight > 0 {
            descriptionStackView.isHidden = true
            tableView.isHidden = false
            tableViewHeightConstraint.constant = tableViewHeight
        }
        else {
            descriptionStackView.isHidden = false
            tableView.isHidden = true
        }
    }

    // MARK: - Actions

    @IBAction func addNewExperienceTapped(_ sender: Any) {
        delegate?.addNewExperience()
    }

    @objc
    private func descriptionAreaTapped() {
        delegate?.addNewExperience()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProfileExperienceCell: UITableViewDelegate, UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataModel?.numberOfSections() ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel?.numberOfRowsInSection(section) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let previousItems = indexPath.section > 0
        ? tableView.numberOfRows(inSection: 0)
        : 0
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ExperienceCell.identifier,
            for: indexPath
        ) as? ExperienceCell,
              let dataModel
        else {
            return UITableViewCell()
        }

        cell.configureLayout(
            for: dataModel.experienceDataModels[indexPath.row + previousItems]
        )
        cell.delegate = self

        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataModel else { return }
        let previousItems = indexPath.section > 0
        ? tableView.numberOfRows(inSection: 0)
        : 0
        delegate?.editExperience(withUUID: dataModel.experiences[indexPath.row + previousItems].uuid)
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let dataModel else { return nil }
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true

        if section == 0 {
            if dataModel.experiences.filter({ $0.professional }).count > 0 {
                label.text = "experience_professional".localized()
            }
            else {
                label.text = "experience_educational".localized()
            }
        }
        else {
            label.text = "experience_educational".localized()
        }

        label.textColor = UIColor(hexString: "#14C3AD")
        label.font = UIFont.scriptFont(.bold, size: 14)
        return view
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

// MARK: - ExperienceCellDelegate
extension ProfileExperienceCell: ExperienceCellDelegate {

    func didTrashTap(_ cell: ExperienceCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let dataModel
        else {
            return
        }
        let previousItems = indexPath.section > 0
        ? tableView.numberOfRows(inSection: 0)
        : 0

        delegate?.deleteExperience(withUUID: dataModel.experiences[indexPath.row + previousItems].uuid)
    }
}

// MARK: - ProfileExperienceCell.DataModel
extension ProfileExperienceCell {

    public class DataModel {

        public struct ExperienceUI {
            let uuid: String
            let professional: Bool
            let organisation: String
            let position: String
            let dateText: String

            public init(
                uuid: String,
                professional: Bool,
                organisation: String,
                position: String,
                dateText: String
            ) {
                self.uuid = uuid
                self.professional = professional
                self.organisation = organisation
                self.position = position
                self.dateText = dateText
            }
        }

        // MARK: - Properties

        let title: String
        let description: String
        let experiences: [ExperienceUI]
        let experienceDataModels: [ExperienceCell.DataModel]

        // MARK: - Constructors/Destructors

        public init(
            title: String,
            description: String,
            experiences: [ExperienceUI]
        ) {
            self.title = title
            self.description = description
            self.experiences = experiences.sorted(by: { $0.professional && !$1.professional })
            self.experienceDataModels = self.experiences
                .compactMap {
                    .init(
                        organisation: $0.organisation,
                        position: $0.position,
                        dates: $0.dateText
                    )
                }
        }

        func tableViewHeight(in contentView: UIView) -> CGFloat {
            let sectionHeight: CGFloat = 34

            var totalHeight: CGFloat = 0
            let professionalExperiencesNum = experiences.filter { $0.professional }.count
            let educationalExperiencesNum = experiences.filter { !$0.professional }.count

            if professionalExperiencesNum > 0 {
                totalHeight += sectionHeight
            }

            experienceDataModels.forEach { experience in
                totalHeight += experience.sizeForItem(in: contentView).height
            }

            if educationalExperiencesNum > 0 {
                totalHeight += sectionHeight
            }

            return totalHeight
        }

        // MARK: - Methods

        func numberOfSections() -> Int {
            var number: Int = 0

            if experiences.filter({ $0.professional }).count > 0 {
                number += 1
            }
            if experiences.filter({ !$0.professional }).count > 0 {
                number += 1
            }
            return number
        }

        func numberOfRowsInSection(_ section: Int) -> Int {
            let professionalExperience = experiences.filter({ $0.professional })
            let educationalExperience = experiences.filter({ !$0.professional })

            if section == .zero {
                return (professionalExperience.count > 0)
                ? professionalExperience.count
                : educationalExperience.count
            }
            else {
                return educationalExperience.count
            }
        }

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
            let tableHeight = tableViewHeight(in: contentView)

            if tableHeight > 0 {
                totalCellHeight = topSpacing
                + titleHeight
                + 16
                + tableHeight
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
