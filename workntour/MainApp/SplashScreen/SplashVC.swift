//
//  SplashVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 11/5/22.
//

import UIKit

class SplashVC: BaseVC {
    private(set) var viewModel: SplashViewModel

    private lazy var bottomText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.textColor = .black
        return label
    }()

    init(_ viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        self.title = "Splash Screen"

        self.viewModel.input.send(())

        view.addSubview(bottomText)
        bottomText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32).isActive = true
        bottomText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    override func bindViews() {
        viewModel.$entries
            .dropFirst()
            .sink(receiveCompletion: { print("completion: \($0)") },
                  receiveValue: {
                self.bottomText.text = $0.first?.entryDescription
            })
            .store(in: &storage)

        viewModel.$errorMessage
            .dropFirst()
            .sink { [weak self] message in
                self?.bottomText.text = message
            }
            .store(in: &storage)
    }

}
