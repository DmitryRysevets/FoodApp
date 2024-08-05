//
//  LoginVC.swift
//  FoodApp
//

import UIKit

final class LoginVC: UIViewController {
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 550])
        label.text = "Login"
        return label
    }()
    
    private lazy var loginField: TextField = {
        let field = TextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.returnKeyType = .next
        field.delegate = self
        return field
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 550])
        label.text = "Password"
        return label
    }()
    
    private lazy var passwordField: TextField = {
        let field = TextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.isSecureTextEntry = true
        field.returnKeyType = .done
        field.delegate = self
        return field
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.regularButtonHeight / 2
        button.backgroundColor = ColorManager.shared.regularButtonColor
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.6), for: .highlighted)
        button.titleLabel?.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [Constants.fontWeightAxis : 550])
        button.addTarget(self, action: #selector(loginButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(loginButtonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        return button
    }()
    
    private lazy var dontHaveAccountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 550])
        label.text = "Don't have an account?"
        return label
    }()
    
    private lazy var createAccountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(ColorManager.shared.login_secondaryButtonColor, for: .normal)
        button.setTitleColor(ColorManager.shared.login_secondaryButtonColor.withAlphaComponent(0.6), for: .highlighted)
        button.titleLabel?.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 550])
        button.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
        loginField.becomeFirstResponder()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.background
        
        view.addSubview(loginLabel)
        view.addSubview(loginField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(dontHaveAccountLabel)
        view.addSubview(createAccountButton)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
            loginLabel.leadingAnchor.constraint(equalTo: loginField.leadingAnchor, constant: 16),
            loginField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            loginField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            loginField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            loginField.heightAnchor.constraint(equalToConstant: Constants.regularFieldHeight),
            
            passwordLabel.topAnchor.constraint(equalTo: loginField.bottomAnchor, constant: 12),
            passwordLabel.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor, constant: 16),
            passwordField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            passwordField.heightAnchor.constraint(equalToConstant: Constants.regularFieldHeight),
            
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 80),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            loginButton.heightAnchor.constraint(equalToConstant: Constants.regularButtonHeight),
            
            dontHaveAccountLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            dontHaveAccountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccountButton.topAnchor.constraint(equalTo: dontHaveAccountLabel.bottomAnchor, constant: 8),
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func authenticateUser() {
        if isFormValid() {
            
        } else {
            
        }
    }
    
    private func isFormValid() -> Bool{
        if let login = loginField.text, !login.isEmpty {
            return false
        }
        
        if let password = passwordField.text, !password.isEmpty {
            return false
        }
        
        return true
    }
    
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
        authenticateUser()
    }
    
    @objc
    private func createAccountButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }

}

// MARK: - UITextFieldDelegate

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField && !loginField.text!.isEmpty {
            textField.resignFirstResponder()
            authenticateUser()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
}
