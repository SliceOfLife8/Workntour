//
//  HostProfileVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 19/6/22.
//

import UIKit
import SharedKit
import CommonUI
import KDCircularProgress

class HostProfileVC: BaseVC<HostProfileViewModel, ProfileCoordinator> {
    private(set) var isCompany: Bool = false

    @IBOutlet weak var progressBar: KDCircularProgress!
    @IBOutlet weak var hostIcon: UIImageView!
    @IBOutlet weak var percentBtn: GradientButton!
    @IBOutlet weak var hostName: UILabel!
    @IBOutlet weak var hostTypeChip: UIButton!
    @IBOutlet weak var introLabel: UILabel!

    // MARK: - Inits
    init(_ isHostCompany: Bool) {
        self.isCompany = isHostCompany
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.title = "Chris Petimezas"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        progressBar.animate(fromAngle: 0, toAngle: 360, duration: 2, completion: { _ in
            self.percentBtn.setTitle("100% Complete", for: .normal)
            self.percentBtn.isHidden = false
        })
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        percentBtn.isHidden = true
        progressBar.stopAnimation()
    }

    override func setupTexts() {
        super.setupTexts()

        hostName.text = "Chris Petimezas"
        hostTypeChip.setTitle("Company", for: .normal)
        // swiftlint:disable line_length
        introLabel.text = "Introduce yourself to us, so that we can go ahead and promote the opportunities that you have to offer. Please indicate what type of host you are and tell us about your project or business to help us understand your needs."
        let introPart = "Introduce yourself to us,"
        introLabel.changeFont(ofText: introPart, with: UIFont.scriptFont(.bold, size: 16))
        introLabel.changeTextColor(ofText: introPart, with: UIColor.appColor(.lavender))
    }

    override func setupUI() {
        super.setupUI()

        hostTypeChip.layer.cornerRadius = 12
        introLabel.setLineHeight(lineHeight: 1.33)
    }

    // MARK: - Actions
    @IBAction func uploadImageTapped(_ sender: Any) {
        print("upload image tapped!")
    }
}
