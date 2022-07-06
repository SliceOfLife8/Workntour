//
//  ImageViewController.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 4/7/22.
//

import UIKit
import SharedKit
import Kingfisher

class ImageViewController: UIViewController {
    private let imageURL: URL?

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.kf.setImage(with: imageURL)
        view.clipsToBounds = true

        return view
    }()

    init(imageURL: URL?) {
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        markup()
    }

    private func markup() {
        view.addSubview(imageView)

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
