//
//  TabBarVC.swift
//  FoodApp
//

import UIKit

class TabBarVC: UIViewController {
    
    lazy var tabBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = tabBarHeight / 2
        view.backgroundColor = ColorManager.shared.label.withAlphaComponent(0.5)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowRadius = 30
        return view
    }()
    
    private lazy var blurEffect: UIVisualEffectView = {
        let view = UIVisualEffectView()
        let blur = UIBlurEffect(style: .regular)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = tabBarHeight / 2
        view.clipsToBounds = true
        view.effect = blur
        return view
    }()
    
    private lazy var tabStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var menuTabButton: TabBarButton = {
        let button = TabBarButton()
        button.addTarget(self, action: #selector(tabDidTaped), for: .touchUpInside)
        button.tag = 0
        button.setLayout(for: tabSize)
        button.setName("Menu")
        button.initSelection()
        
        return button
    }()
    
    private lazy var favoriteTabButton: TabBarButton = {
        let button = TabBarButton()
        button.addTarget(self, action: #selector(tabDidTaped), for: .touchUpInside)
        button.tag = 1
        button.setLayout(for: tabSize)
        button.setName("Favorite")
        
        return button
    }()
    
    private lazy var cartTabButton: TabBarButton = {
        let button = TabBarButton()
        button.addTarget(self, action: #selector(tabDidTaped), for: .touchUpInside)
        button.tag = 2
        button.setLayout(for: tabSize)
        button.setName("Cart")
        
        return button
    }()
    
    private lazy var profileTabButton: TabBarButton = {
        let button = TabBarButton()
        button.addTarget(self, action: #selector(tabDidTaped), for: .touchUpInside)
        button.tag = 3
        button.setLayout(for: tabSize)
        button.setName("Profile")
        
        return button
    }()
    
    private lazy var tabs = [menuTabButton, favoriteTabButton, cartTabButton, profileTabButton]
    
    private var selectedIndex: Int = 0
    private var previousIndex: Int = 0
    
    private let tabBarHeight: CGFloat = 72
    private let tabBarMargin: CGFloat = 40
    private let tabMargin: CGFloat = 6
    private var tabSize: CGFloat { tabBarHeight - tabMargin * 2 }
    
    private var viewControllers = [UIViewController]()
    
    static let menuVC = MenuTabVC()
    static let favoriteVC = FavoriteTabVC()
    static let cartVC = CartTabVC()
    static let profileVC = ProfileTabVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers.append(TabBarVC.menuVC)
        viewControllers.append(TabBarVC.favoriteVC)
        viewControllers.append(TabBarVC.cartVC)
        viewControllers.append(TabBarVC.profileVC)
        
        tabs[selectedIndex].isSelected = true
        
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.background
        view.addSubview(tabBarView)
        tabBarView.addSubview(blurEffect)
        tabBarView.addSubview(tabStack)
        tabStack.addArrangedSubview(menuTabButton)
        tabStack.addArrangedSubview(favoriteTabButton)
        tabStack.addArrangedSubview(cartTabButton)
        tabStack.addArrangedSubview(profileTabButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tabBarView.heightAnchor.constraint(equalToConstant: tabBarHeight),
            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: tabBarMargin),
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -tabBarMargin),
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarMargin),
            
            blurEffect.topAnchor.constraint(equalTo: tabBarView.topAnchor),
            blurEffect.leadingAnchor.constraint(equalTo: tabBarView.leadingAnchor),
            blurEffect.trailingAnchor.constraint(equalTo: tabBarView.trailingAnchor),
            blurEffect.bottomAnchor.constraint(equalTo: tabBarView.bottomAnchor),
            
            tabStack.topAnchor.constraint(equalTo: tabBarView.topAnchor, constant: tabMargin),
            tabStack.leadingAnchor.constraint(equalTo: tabBarView.leadingAnchor, constant: tabMargin),
            tabStack.trailingAnchor.constraint(equalTo: tabBarView.trailingAnchor, constant: -tabMargin),
            tabStack.bottomAnchor.constraint(equalTo: tabBarView.bottomAnchor, constant: -tabMargin)
        ])
        
        tabs.forEach { tab in
            tab.widthAnchor.constraint(equalToConstant: tabSize).isActive = true
        }
    }
}


// MARK: - actions
extension TabBarVC {
    
    @objc
    private func tabDidTaped(_ sender: TabBarButton) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else { return }
        
        previousIndex = selectedIndex
        selectedIndex = sender.tag
        
        tabs[previousIndex].makeUnselected()
        
        let previousVC = viewControllers[previousIndex]
        let currentVC = viewControllers[selectedIndex]
        
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()

        sender.makeSelected()
        
        currentVC.view.frame = window.frame
        currentVC.didMove(toParent: self)
        addChild(currentVC)
        view.addSubview(currentVC.view)
        
        view.bringSubviewToFront(tabBarView)
    }
    
    func hideTabBar() {
        tabBarView.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: { [self] in
            tabBarView.center.y += tabBarHeight + tabBarMargin
        })
    }
    
    func showTabBar() {
        let showTabBarAnimation = CASpringAnimation(keyPath: "position.y")
        showTabBarAnimation.damping = 13
        showTabBarAnimation.fromValue = tabBarView.center.y
        showTabBarAnimation.toValue = tabBarView.center.y - (tabBarHeight + tabBarMargin)
        showTabBarAnimation.duration = showTabBarAnimation.settlingDuration
        
        CATransaction.begin()
        tabBarView.layer.position.y -= tabBarHeight + tabBarMargin
        tabBarView.layer.add(showTabBarAnimation, forKey: "positionAnimation")
        CATransaction.commit()
    }

}
