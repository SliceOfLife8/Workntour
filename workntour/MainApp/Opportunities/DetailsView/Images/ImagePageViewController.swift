//
//  ImagePageViewController.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 4/7/22.
//

import UIKit
import SnapKit
import CommonUI

protocol ImagePageViewControllerDelegate: AnyObject {
    func imagePageViewController(didScrollTo index: Int)
}

class ImagePageViewController: UIViewController {
    weak var delegate: ImagePageViewControllerDelegate?
    private var currentPage: Int = 0

    private var viewControllers: [UIViewController] = []

    private lazy var pageController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll,
                                      navigationOrientation: .horizontal,
                                      options: nil)
        addChild(vc)
        view.addSubview(vc.view)
        vc.didMove(toParent: self)

        return vc
    }()

    private lazy var pageControl: PageControl = {
        let view = PageControl()
        view.isHidden = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        pageController.delegate = self
        pageController.dataSource = self
        view.backgroundColor = UIColor.appColor(.lavender).withAlphaComponent(0.2)
        markup()
    }

    public func reloadData(withImages imageURLs: [URL?]) {
        viewControllers = imageURLs.map { ImageViewController(imageURL: $0) }
        pageControl.numberOfPages = imageURLs.count
        pageControl.isHidden = imageURLs.count > 1 ? false : true

        if let vc = viewControllers.first {
            pageController.setViewControllers([vc],
                                              direction: .forward,
                                              animated: false,
                                              completion: nil)
        }
    }

    private func markup() {
        view.addSubview(pageControl)

        pageController.view.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(view.snp.left).offset(-2)
            $0.right.equalTo(view.snp.right).offset(2)
            $0.bottom.equalToSuperview()
        }

        pageControl.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-16)
            $0.centerX.equalToSuperview()
        }
    }
}

extension ImagePageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = self.viewControllers.firstIndex(of: viewController),
              currentIndex - 1 >= 0 else {
            return nil
        }

        return viewControllers[currentIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = self.viewControllers.firstIndex(of: viewController),
              currentIndex + 1 < self.viewControllers.count else {
            return nil
        }

        return viewControllers[currentIndex + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
              let vc = pageViewController.viewControllers?.first,
              let index = viewControllers.firstIndex(of: vc) else {
            return
        }

        delegate?.imagePageViewController(didScrollTo: index)
        pageControl.currentPage = index
    }
}
