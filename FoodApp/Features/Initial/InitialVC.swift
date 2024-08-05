//
//  InitialVC.swift
//  FoodApp
//

import UIKit

final class InitialVC: UIViewController {
    
    private lazy var weDeliverLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 55, axis: [Constants.fontWeightAxis : 650])
        label.numberOfLines = 3
        label.text = """
            We
            Deliver
            Fresh Food
            """
        return label
    }()
    
    private lazy var imageBackingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorManager.shared.label.withAlphaComponent(0.1)
        view.layer.cornerRadius = 80
        return view
    }()
    
    private lazy var handWithBurgerImageView: UIImageView = {
        let image = UIImage(named: "HandWithBurger")
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
    }
    
    // MARK: - private methods
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.initialVC_background
        
        view.addSubview(weDeliverLabel)
        view.addSubview(imageBackingView)
        view.addSubview(handWithBurgerImageView)
        view.addSubview(loginButton)
        view.addSubview(createAccountButton)
        view.addSubview(continueAsGuestButton)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            weDeliverLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 48),
            weDeliverLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            weDeliverLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            imageBackingView.topAnchor.constraint(equalTo: handWithBurgerImageView.topAnchor, constant: 65),
            imageBackingView.leadingAnchor.constraint(equalTo: handWithBurgerImageView.leadingAnchor, constant: 12),
            imageBackingView.heightAnchor.constraint(equalToConstant: 270),
            imageBackingView.widthAnchor.constraint(equalTo: imageBackingView.heightAnchor),
            
            handWithBurgerImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            handWithBurgerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 80),
            handWithBurgerImageView.heightAnchor.constraint(equalToConstant: 450),
            handWithBurgerImageView.widthAnchor.constraint(equalTo: handWithBurgerImageView.heightAnchor),
            
            continueAsGuestButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            continueAsGuestButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            continueAsGuestButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            continueAsGuestButton.heightAnchor.constraint(equalToConstant: Constants.regularButtonHeight),
            
            createAccountButton.bottomAnchor.constraint(equalTo: continueAsGuestButton.topAnchor, constant: -16),
            createAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            createAccountButton.heightAnchor.constraint(equalToConstant: Constants.regularButtonHeight),
            
            loginButton.bottomAnchor.constraint(equalTo: createAccountButton.topAnchor, constant: -16),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            loginButton.heightAnchor.constraint(equalToConstant: Constants.regularButtonHeight),
        ])
    }
    
    // MARK: - objc methods

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
        dismiss(animated: true)
    }
    
}
