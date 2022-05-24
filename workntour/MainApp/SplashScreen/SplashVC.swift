//
//  SplashVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 11/5/22.
//

import UIKit

class SplashVC: BaseVC<SplashViewModel, MainCoordinator> {

    private lazy var bottomText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        self.title = "Splash Screen"

        self.viewModel?.input.send(())

        view.addSubview(bottomText)
        bottomText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32).isActive = true
        bottomText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        bottomText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
    }

    override func bindViews() {
//        viewModel?.$entries
//            .compactMap { $0.first }
//            .sink(receiveCompletion: { print("completion: \($0)") },
//                  receiveValue: {
//                self.bottomText.text = $0.entryDescription
//            })
//            .store(in: &storage)

        viewModel?.$errorMessage
            .dropFirst()
            .sink { [weak self] message in
                self?.bottomText.text = message
            }
            .store(in: &storage)
    }

}
