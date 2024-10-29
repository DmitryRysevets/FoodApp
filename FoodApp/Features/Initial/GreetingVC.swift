//
//  GreetingVC.swift
//  FoodApp
//

import UIKit

final class GreetingVC: UIViewController {
    
    private lazy var ringView1 = UIView()
    private lazy var ringView2 = UIView()
    private lazy var ringView3 = UIView()
    
    private lazy var weLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 55, axis: [Constants.fontWeightAxis : 650])
        label.text = "We"
        return label
    }()
    
    private lazy var deliverLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 55, axis: [Constants.fontWeightAxis : 650])
        label.text = "Deliver"
        return label
    }()
    
    private lazy var freshFoodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 55, axis: [Constants.fontWeightAxis : 650])
        label.text = "Fresh Food"
        return label
    }()
    
    private lazy var imageBackingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorManager.shared.label.withAlphaComponent(0.1)
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.cornerRadius = 100
        return view
    }()
    
    private lazy var handWithBurgerImageView: UIImageView = {
        let image = UIImage(named: "HandWithBurger")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var pastaImageView: UIImageView = {
        let image = UIImage(named: "Pasta")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ColorManager.shared.initialVC_loginButtonColor
        button.layer.cornerRadius = 26
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.6), for: .highlighted)
        button.titleLabel?.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [Constants.fontWeightAxis : 550])
        button.addTarget(self, action: #selector(loginButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(loginButtonTouchUp), for: [.touchUpInside, .touchUpOutside])
        return button
    }()
    
    private lazy var createAccountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ColorManager.shared.initialVC_createAccountButtonColor
        button.layer.cornerRadius = 26
        button.setTitle("Сreate Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.6), for: .highlighted)
        button.titleLabel?.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [Constants.fontWeightAxis : 550])
        button.addTarget(self, action: #selector(createAccountButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(createAccountButtonTouchUp), for: [.touchUpInside, .touchUpOutside])
        return button
    }()
    
    private lazy var continueAsGuestButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 26
        button.setTitle("Continue as a guest", for: .normal)
        button.setTitleColor(ColorManager.shared.initialVC_continueAsGuestButtonColor, for: .normal)
        button.setTitleColor(ColorManager.shared.initialVC_continueAsGuestButtonColor.withAlphaComponent(0.6), for: .highlighted)
        button.titleLabel?.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 550])
        button.addTarget(self, action: #selector(continueAsGuestButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        prepareForAnimations()
    }
    
    override func viewDidLayoutSubviews() {
        setupRingViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimations()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.initialVC_background
        
        view.addSubview(pastaImageView)
        view.addSubview(ringView1)
        view.addSubview(ringView2)
        view.addSubview(ringView3)
        view.addSubview(weLabel)
        view.addSubview(deliverLabel)
        view.addSubview(freshFoodLabel)
        view.addSubview(imageBackingView)
        view.addSubview(handWithBurgerImageView)
        view.addSubview(loginButton)
        view.addSubview(createAccountButton)
        view.addSubview(continueAsGuestButton)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        [ringView1, ringView2, ringView3].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            view.centerYAnchor.constraint(equalTo: deliverLabel.centerYAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: 60).isActive = true
            view.widthAnchor.constraint(equalToConstant: 60).isActive = true
        }
        
        NSLayoutConstraint.activate([
            pastaImageView.centerYAnchor.constraint(equalTo: weLabel.centerYAnchor),
            pastaImageView.leadingAnchor.constraint(equalTo: weLabel.leadingAnchor, constant: 100),
            pastaImageView.heightAnchor.constraint(equalToConstant: 80),
            pastaImageView.widthAnchor.constraint(equalToConstant: 80),
            
            ringView1.leadingAnchor.constraint(equalTo: deliverLabel.leadingAnchor, constant: 200),
            ringView2.leadingAnchor.constraint(equalTo: ringView1.leadingAnchor, constant: 36),
            ringView3.leadingAnchor.constraint(equalTo: ringView1.leadingAnchor, constant: 72),
            
            weLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 48),
            weLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            weLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            deliverLabel.topAnchor.constraint(equalTo: weLabel.bottomAnchor),
            deliverLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            deliverLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            freshFoodLabel.topAnchor.constraint(equalTo: deliverLabel.bottomAnchor),
            freshFoodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            freshFoodLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            imageBackingView.topAnchor.constraint(equalTo: freshFoodLabel.bottomAnchor, constant: -112),
            imageBackingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -99),
            imageBackingView.heightAnchor.constraint(equalToConstant: 270),
            imageBackingView.widthAnchor.constraint(equalTo: imageBackingView.heightAnchor),
            
            handWithBurgerImageView.topAnchor.constraint(equalTo: imageBackingView.topAnchor, constant: 72),
            handWithBurgerImageView.leadingAnchor.constraint(equalTo: imageBackingView.leadingAnchor, constant: 124),
            handWithBurgerImageView.heightAnchor.constraint(equalToConstant: 450),
            handWithBurgerImageView.widthAnchor.constraint(equalTo: handWithBurgerImageView.heightAnchor),
            
            loginButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -128),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            loginButton.heightAnchor.constraint(equalToConstant: Constants.regularButtonHeight),
            
            createAccountButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -60),
            createAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            createAccountButton.heightAnchor.constraint(equalToConstant: Constants.regularButtonHeight),

            continueAsGuestButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            continueAsGuestButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            continueAsGuestButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            continueAsGuestButton.heightAnchor.constraint(equalToConstant: Constants.regularButtonHeight)
        ])
    }
    
    func setupRingViews() {
        [ringView1, ringView2, ringView3].forEach { view in
            view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            
            let ringLayer = CAShapeLayer()
            let radius = min(view.bounds.width, view.bounds.height) / 2 - 4
            
            let centerPoint = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
            let circularPath = UIBezierPath(
                arcCenter: centerPoint,
                radius: radius,
                startAngle: 0,
                endAngle: CGFloat.pi * 2,
                clockwise: true
            )
            
            ringLayer.path = circularPath.cgPath
            ringLayer.fillColor = UIColor.clear.cgColor
            ringLayer.strokeColor = ColorManager.shared.label.cgColor
            ringLayer.lineWidth = 2
            ringLayer.frame = view.bounds
            
            view.layer.addSublayer(ringLayer)
        }
    }
    
    private func prepareForAnimations() {
        let labels = [weLabel, deliverLabel, freshFoodLabel]
        labels.forEach {
            $0.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
            $0.alpha = 0.0
        }
        
        [pastaImageView, ringView1, ringView2, ringView3].forEach {
            $0.transform = CGAffineTransform(translationX: view.bounds.width, y: 0)
            $0.alpha = 0.0
        }
        
        imageBackingView.layer.anchorPoint = CGPoint(x: 0, y: 0)
        imageBackingView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        
        handWithBurgerImageView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            .concatenating(CGAffineTransform(translationX: 200, y: 300))

        let buttons = [loginButton, createAccountButton, continueAsGuestButton]
            buttons.forEach {
            $0.transform = CGAffineTransform(translationX: 0, y: 100)
            $0.alpha = 0.0
        }
    }
    
    private func startAnimations() {
        let labels = [weLabel, deliverLabel, freshFoodLabel]
        for (index, label) in labels.enumerated() {
            UIView.animate(withDuration: 0.7, delay: 0.2 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
                label.transform = .identity
                label.alpha = 1.0
            }
        }
        
        let rings = [ringView1, ringView2, ringView3]
        for (index, ring) in rings.enumerated() {
            UIView.animate(withDuration: 0.7, delay: 0.2 + (0.1 * Double(index)), usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5) {
                ring.transform = .identity
                ring.alpha = 1.0
            }
        }
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.4, options: [.curveEaseInOut]) {
            self.pastaImageView.transform = .identity
            self.pastaImageView.alpha = 1
        }
        
        UIView.animate(withDuration: 0.9, delay: 0.7, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.4, options: [.curveEaseInOut]) {
            self.imageBackingView.transform = .identity
        }

        UIView.animate(withDuration: 0.9, delay: 0.7, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4) {
            self.handWithBurgerImageView.transform = .identity
        }

        UIView.animate(withDuration: 0.7, delay: 0.7, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            self.loginButton.transform = .identity
            self.loginButton.alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.7, delay: 0.9, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            self.createAccountButton.transform = .identity
            self.createAccountButton.alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.7, delay: 1.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            self.continueAsGuestButton.transform = .identity
            self.continueAsGuestButton.alpha = 1.0
        }
    }
    
    private func goToMain() {
        guard let windowFrame = view.window?.frame else { return }
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let mainVС = TabBarVC()
            mainVС.initialSetup(with: windowFrame)
            sceneDelegate.switchRootViewController(to: mainVС)
        }
    }
    
    // MARK: - Objc methods

    @objc
    private func loginButtonTouchDown() {
        UIView.animate(withDuration: 0.05) {
            self.loginButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc
    private func loginButtonTouchUp() {
        UIView.animate(withDuration: 0.05, delay: 0.05, options: [], animations: {
            self.loginButton.transform = CGAffineTransform.identity
        }, completion: nil)
        
        let vc = LoginVC()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc
    private func createAccountButtonTouchDown() {
        UIView.animate(withDuration: 0.05) {
            self.createAccountButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc
    private func createAccountButtonTouchUp() {
        UIView.animate(withDuration: 0.05, delay: 0.05, options: [], animations: {
            self.createAccountButton.transform = CGAffineTransform.identity
        }, completion: nil)
        
        let vc = CreateAccountVC()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc
    private func continueAsGuestButtonTapped() {
        goToMain()
    }
    
}
