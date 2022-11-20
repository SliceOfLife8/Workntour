//
//  LanguagePickerVC.swift
//  workntour
//
//  Created by Chris Petimezas on 14/11/22.
//

import UIKit
import CommonUI
import DropDown

class LanguagePickerVC: BaseVC<LanguagePickerViewModel, ProfileCoordinator> {

    // MARK: - Outlets

    @IBOutlet weak var mainStackView: UIStackView!

    @IBOutlet weak var languageTextField: GradientTextField! {
        didSet {
            languageLabel.text = "language".localized()
            languageTextField.configure(
                placeHolder: "select_language".localized(),
                type: .noEditable
            )
            languageTextField.gradientDelegate = self
        }
    }

    @IBOutlet weak var languageLabel: UILabel!

    @IBOutlet weak var profiencyLabel: UILabel!

    @IBOutlet weak var chipsCollectionView: DynamicHeightCollectionView! {
        didSet {
            chipsCollectionView.register(
                UINib(nibName: ChipCell.identifier,
                      bundle: Bundle(for: ChipCell.self)),
                forCellWithReuseIdentifier: ChipCell.identifier
            )
            chipsCollectionView.delegate = self
            chipsCollectionView.dataSource = self
        }
    }

    @IBOutlet weak var footerLabel: UILabel!

    // MARK: - Properties

    private lazy var languagesDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = viewModel?.data.languages.map { $0.value } ?? []
        dropDown.dismissMode = .onTap

        dropDown.customCellConfiguration = { (_, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.text = item
        }

        dropDown.selectionAction = { [unowned self] (_, item: String) in
            languageTextField.text = item
            languageTextField.arrowTapped()
            guard let language = Language(caseName: item) else { return }
            viewModel?.updateLanguage(language)
        }

        dropDown.cancelAction = { [unowned self] in
            languageTextField.arrowTapped()
        }

        return dropDown
    }()

    // MARK: - Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationBar(mainTitle: "languages".localized())

        if viewModel?.editLanguage == nil {
            let saveAction = UIBarButtonItem(
                title: "save".localized(),
                style: .plain,
                target: self,
                action: #selector(saveBtnTapped)
            )
            navigationItem.rightBarButtonItems = [saveAction]
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        else {
            let bar = UIBarButtonItem(
                image: UIImage(systemName: "circle.grid.3x3"),
                style: .plain,
                target: self,
                action: nil
            )
            self.navigationItem.rightBarButtonItem = bar
            self.navigationItem.rightBarButtonItem?.menu = addMenuItemsToBarItem()
        }
    }

    override func setupUI() {
        super.setupUI()

        mainStackView.setCustomSpacing(32, after: languageTextField)
        profiencyLabel.text = "proficiency".localized()
        mainStackView.setCustomSpacing(80, after: chipsCollectionView)
        footerLabel.text = "languages_bottom_information".localized()
    }

    override func bindViews() {
        super.bindViews()

        viewModel?.$language
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] status in
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
            })
            .store(in: &storage)

        viewModel?.$editLanguage
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] profileLang in
                // Update VM + UI
                self?.viewModel?.lang = profileLang.language
                self?.viewModel?.prof = profileLang.proficiency

                self?.languageTextField.text = profileLang.language.value
                self?.languageTextField.backgroundColor = UIColor(hexString: "#667085").withAlphaComponent(0.2)
                self?.languageTextField.isUserInteractionEnabled = false
                self?.chipsCollectionView.selectItem(
                    at: IndexPath(row: profileLang.proficiency.rawValue, section: 0),
                    animated: false,
                    scrollPosition: .centeredVertically
                )
            })
            .store(in: &storage)
    }

    // MARK: - Private Methods

    func addMenuItemsToBarItem() -> UIMenu {
        // Create actions
        let updateAction = UIAction(
            title: "Update",
            image: UIImage(systemName: "flag.fill"),
            handler: { [weak self] _ in
                guard let profileDto = self?.viewModel?.profileDto,
                      let language = self?.viewModel?.language
                else {
                    assertionFailure("Check why language obj is nil")
                    return
                }

                self?.coordinator?.modifyLanguage(
                    mode: .edit,
                    language: language,
                    profileDto: profileDto
                )
            })

        let deleteAction = UIAction(
            title: "Delete",
            image: UIImage(systemName: "trash")?.withTintColor(.red, renderingMode: .alwaysOriginal),
            handler: { [weak self] _ in
                guard let profileDto = self?.viewModel?.profileDto,
                      let language = self?.viewModel?.language
                else {
                    assertionFailure("Check why language obj is nil")
                    return
                }

                self?.coordinator?.modifyLanguage(
                    mode: .delete,
                    language: language,
                    profileDto: profileDto
                )
            })

        // Use the .displayInline option to avoid displaying the menu as a submenu,
        // and to separate it from the other menu elements using a line separator.
        return UIMenu(title: "", options: .displayInline, children: [updateAction, deleteAction])
    }

    // MARK: - Actions

    @objc private func saveBtnTapped() {
        guard let profileDto = viewModel?.profileDto,
              let language = viewModel?.language
        else {
            return
        }

        coordinator?.modifyLanguage(
            mode: .add,
            language: language,
            profileDto: profileDto
        )
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension LanguagePickerVC: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.data.proficiencies.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ChipCell.identifier,
            for: indexPath
        ) as? ChipCell,
              let proficiency = viewModel?.data.proficiencies[safe: indexPath.row]
        else {
            return UICollectionViewCell()
        }

        cell.configureLayout(for: .init(title: proficiency.value))

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let proficiency = viewModel?.data.proficiencies[safe: indexPath.row] else { return }
        viewModel?.updateLanguageProficiency(proficiency)
    }
}

// MARK: - GradientTextFieldDelegate
extension LanguagePickerVC: GradientTFDelegate {

    func shouldReturn(_ textField: UITextField) {
        view.endEditing(true)
    }

    func notEditableTextFieldTriggered(_ textField: UITextField) {
        languagesDropDown.anchorView = textField
        languagesDropDown.show()
    }
}
