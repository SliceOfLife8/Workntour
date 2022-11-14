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

    @IBOutlet weak var languageTextField: GradientTextField!

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
            print("update viewmodel")
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
        let saveAction = UIBarButtonItem(
            title: "save".localized(),
            style: .plain,
            target: self,
            action: #selector(saveBtnTapped)
        )
        navigationItem.rightBarButtonItems = [saveAction]
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    override func setupUI() {
        super.setupUI()

        languageLabel.text = "language".localized()
        languageTextField.configure(
            placeHolder: "select_language".localized(),
            type: .noEditable
        )
        languageTextField.gradientDelegate = self
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
                print("status: \(status)")
            })
            .store(in: &storage)
    }

    // MARK: - Actions

    @objc private func saveBtnTapped() {
        print("api")
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
        print("didSelect: \(proficiency)")
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
