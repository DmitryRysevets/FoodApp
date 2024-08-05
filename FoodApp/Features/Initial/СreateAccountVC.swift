//
//  СreateAccountVC.swift
//  FoodApp
//

import UIKit

final class CreateAccountVC: UIViewController {
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 550])
        label.text = "Login *"
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
        label.text = "Password *"
        return label
    }()
    
    private lazy var passwordField: TextField = {
        let field = TextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.isSecureTextEntry = true
        field.returnKeyType = .next
        field.delegate = self
        return field
    }()
    
    private lazy var confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 550])
        label.text = "Confirm Password *"
        return label
    }()
    
    private lazy var confirmPasswordField: TextField = {
        let field = TextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.isSecureTextEntry = true
        field.returnKeyType = .next
        field.delegate = self
        return field
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 550])
        label.text = "Email"
        return label
    }()
    
    private lazy var emailField: TextField = {
        let field = TextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardType = .emailAddress
        field.returnKeyType = .done
        field.delegate = self
        return field
    }()
    
    private lazy var createAccountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.regularButtonHeight / 2
        button.backgroundColor = ColorManager.shared.regularButtonColor
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.6), for: .highlighted)
        button.titleLabel?.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [Constants.fontWeightAxis : 550])
        button.addTarget(self, action: #selector(createAccountButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(createAccountButtonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        return button
    }()
    
    private lazy var alreadyHaveAccountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 550])
        label.text = "Already have an account?"
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(ColorManager.shared.login_secondaryButtonColor, for: .normal)
        button.setTitleColor(ColorManager.shared.login_secondaryButtonColor.withAlphaComponent(0.6), for: .highlighted)
        button.titleLabel?.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 550])
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
//        loginField.becomeFirstResponder()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.background
        
        view.addSubview(loginLabel)
        view.addSubview(loginField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordField)
        view.addSubview(confirmPasswordLabel)
        view.addSubview(confirmPasswordField)
        view.addSubview(emailLabel)
        view.addSubview(emailField)
        view.addSubview(createAccountButton)
        view.addSubview(alreadyHaveAccountLabel)
        view.addSubview(loginButton)
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
            
            confirmPasswordLabel.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 12),
            confirmPasswordLabel.leadingAnchor.constraint(equalTo: confirmPasswordField.leadingAnchor, constant: 16),
            confirmPasswordField.topAnchor.constraint(equalTo: confirmPasswordLabel.bottomAnchor, constant: 8),
            confirmPasswordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            confirmPasswordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            confirmPasswordField.heightAnchor.constraint(equalToConstant: Constants.regularFieldHeight),
            
            emailLabel.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: 12),
            emailLabel.leadingAnchor.constraint(equalTo: emailField.leadingAnchor, constant: 16),
            emailField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailField.heightAnchor.constraint(equalToConstant: Constants.regularFieldHeight),
            
            createAccountButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 80),
            createAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            createAccountButton.heightAnchor.constraint(equalToConstant: Constants.regularButtonHeight),
            
            alreadyHaveAccountLabel.topAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: 20),
            alreadyHaveAccountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: alreadyHaveAccountLabel.bottomAnchor, constant: 8),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func createAccount() {
        if isFormValid() {
            
        } else {
            
        }
    }
    
    private func isFormValid() -> Bool{
        guard let login = loginField.text, !login.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordField.text, !confirmPassword.isEmpty
        else { return false }
        
        if password != confirmPassword  {
            return false
        }
        
        return true
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
        createAccount()
    }
    
    @objc
    private func loginButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension CreateAccountVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            confirmPasswordField.becomeFirstResponder()
        } else if textField == confirmPasswordField {
            emailField.becomeFirstResponder()
        } else if textField == emailField && !loginField.text!.isEmpty {
            textField.resignFirstResponder()
            createAccount()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
}
