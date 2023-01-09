//
//  GenericBottomSheetVC.swift
//  CommonUI
//
//  Created by Chris Petimezas on 9/1/23.
//

import UIKit
import SharedKit
import SnapKit

// MARK: - GenericBottomSheetVC
public class GenericBottomSheetVC: UIViewController {

    // MARK: - Properties

    private var dataModel: DataModel

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appColor(.purpleBlack)
        label.font = UIFont.scriptFont(.bold, size: 25)
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.textColor = UIColor.appColor(.basicText)
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = false
        return textView
    }()

    private lazy var mainButton: PrimaryButton = {
        let button = PrimaryButton()
        button.radius = 6
        button.enabledStateColor = UIColor.appColor(.lavender)
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mainButtonTapped)))
        return button
    }()

    // MARK: - Construstors/Destructors

    required public init(dataModel: DataModel) {
        self.dataModel = dataModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override public func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.appColor(.primary)
        view.addSubview(mainStackView)

        mainStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalToSuperview().offset(32)
            $0.right.equalToSuperview().offset(-32)
            $0.bottom.greaterThanOrEqualToSuperview().offset(-32)
        }
        setupStackViewSubviews()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        estimateSize()
    }

    // MARK: - Private Methods

    private func setupStackViewSubviews() {
        titleLabel.text = dataModel.title
        mainStackView.addArrangedSubview(titleLabel)
        descriptionTextView.attributedText = NSAttributedString(string: dataModel.description)
        descriptionTextView.font = UIFont.scriptFont(.medium, size: 17)
        mainStackView.addArrangedSubview(descriptionTextView)
        mainStackView.setCustomSpacing(32, after: descriptionTextView)
        mainButton.setTitle(
            dataModel.buttonText,
            for: .normal
        )
        mainStackView.addArrangedSubview(mainButton)

        mainButton.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(48)
        }
        // Force stackView to update it's contents
        mainStackView.layoutIfNeeded()
    }

    private func estimateSize() {
        guard let window = view.window else { return }
        let totalHeight: CGFloat = view.safeAreaInsets.top
                                + 96 // Pullbar height + top space + TitleLabel's height
                                + 44 // StackView spacing + Button <-> TextView space
                                + mainButton.frame.height
                                + 82 // Bottom space

        // Hack mode here. Please read carefully.
        // In order for a textView to be drawn inside a stackView we need to disable scrolling.
        // On this way, content is stretched and fill out whole area correctly.
        // However, if textView's contentSize is bigger than bottomSheet height, then user should be able to scroll the
        // content. So, we re-enable scrolling behaviour but we are setting the maximum height for textView.
        let textViewMaximumHeight = window.bounds.height - totalHeight
        if descriptionTextView.contentSize.height > textViewMaximumHeight  {
            descriptionTextView.isScrollEnabled = true
            descriptionTextView.snp.remakeConstraints { make in
                make.height.equalTo(textViewMaximumHeight)
            }
        }
        else {
            descriptionTextView.isScrollEnabled = false
            descriptionTextView.snp.removeConstraints()
        }

        self.preferredContentSize = CGSize(
            width: view.frame.width,
            height: mainStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height + 44
        )
    }

    // MARK: - Actions
    @objc func mainButtonTapped() {
        self.dismiss(animated: true) {
            self.dataModel.buttonAction?()
        }
    }
}

// MARK: - GenericBottomSheetVC.DataModel
extension GenericBottomSheetVC {

    public class DataModel {

        // MARK: - Properties

        let title: String
        let description: String
        let buttonText: String
        let buttonAction: (() -> Void)?

        // MARK: - Construstors/Destructors

        public init(
            title: String,
            description: String,
            buttonText: String,
            buttonAction: (() -> Void)? = nil
        ) {
            self.title = title
            self.description = description
            self.buttonText = buttonText
            self.buttonAction = buttonAction
        }
    }
}
