//
//  TabBarVC.swift
//  FoodApp
//

import UIKit

class CartTabVC: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemPink
        return view
    }()
    
    private let scrollStackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let subView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 2000).isActive = true
        return view
    }()
    
    private var tabBarIsVisible = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorManager.shared.background
        setupScrollView()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollStackViewContainer)
        scrollStackViewContainer.addArrangedSubview(subView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])   
    }
}


extension CartTabVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        performTabBarCheck(with: translation)
    }
    
    private func performTabBarCheck(with translation: CGPoint) {
        if translation.y == 0 { return }
        if translation.y > 0 {
            if !tabBarIsVisible { showTabBar() }
        } else {
            if tabBarIsVisible { hideTabBar() }
        }
    }
    
    private func hideTabBar() {
        self.tabBarIsVisible = false
        let parent = parent as! TabBarVC
        parent.hideTabBar()
    }
    
    private func showTabBar() {
        self.tabBarIsVisible = true
        let parent = parent as! TabBarVC
        parent.showTabBar()
    }
}
