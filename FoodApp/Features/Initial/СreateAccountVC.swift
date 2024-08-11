//
//  СreateAccountVC.swift
//  FoodApp
//

import UIKit

final class CreateAccountVC: UIViewController {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 550])
        label.text = "Name"
        return label
    }()
    
    private lazy var nameField: TextField = {
        let field = TextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.associatedLabel = nameLabel
        field.autocapitalizationType = .words
        field.returnKeyType = .next
        field.delegate = self
        return field
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 550])
        label.text = "Email *"
        return label
    }()
    
    private lazy var emailField: TextField = {
        let field = TextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.associatedLabel = emailLabel
        field.autocapitalizationType = .none
        field.keyboardType = .emailAddress
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
        field.associatedLabel = passwordLabel
        field.autocapitalizationType = .none
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
        field.associatedLabel = confirmPasswordLabel
        field.autocapitalizationType = .none
        field.isSecureTextEntry = true
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
    
    private lazy var alreadyHaveAccountView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    private lazy var continueAsGuestView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var orContinueAsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 550])
        label.text = "Or continue as a"
        return label
    }()
    
    private lazy var guestButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("guest", for: .normal)
        button.setTitleColor(ColorManager.shared.login_secondaryButtonColor, for: .normal)
        button.setTitleColor(ColorManager.shared.login_secondaryButtonColor.withAlphaComponent(0.6), for: .highlighted)
        button.titleLabel?.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 550])
        button.addTarget(self, action: #selector(guestButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
//        loginField.becomeFirstResponder()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.background
        
        view.addSubview(nameLabel)
        view.addSubview(nameField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordField)
        view.addSubview(confirmPasswordLabel)
        view.addSubview(confirmPasswordField)
        view.addSubview(emailLabel)
        view.addSubview(emailField)
        view.addSubview(createAccountButton)
        view.addSubview(alreadyHaveAccountView)
        view.addSubview(continueAsGuestView)
        
        alreadyHaveAccountView.addSubview(alreadyHaveAccountLabel)
        alreadyHaveAccountView.addSubview(loginButton)
        continueAsGuestView.addSubview(orContinueAsLabel)
        continueAsGuestView.addSubview(guestButton)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
            nameLabel.leadingAnchor.constraint(equalTo: nameField.leadingAnchor, constant: 16),
            nameField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nameField.heightAnchor.constraint(equalToConstant: Constants.regularFieldHeight),
            
            emailLabel.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 12),
            emailLabel.leadingAnchor.constraint(equalTo: emailField.leadingAnchor, constant: 16),
            emailField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailField.heightAnchor.constraint(equalToConstant: Constants.regularFieldHeight),
            
            passwordLabel.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 12),
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
            
            createAccountButton.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: 80),
            createAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            createAccountButton.heightAnchor.constraint(equalToConstant: Constants.regularButtonHeight),
            
            alreadyHaveAccountView.topAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: 20),
            alreadyHaveAccountView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alreadyHaveAccountView.leadingAnchor.constraint(equalTo: alreadyHaveAccountLabel.leadingAnchor),
            alreadyHaveAccountView.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
            alreadyHaveAccountView.bottomAnchor.constraint(equalTo: loginButton.bottomAnchor),
            loginButton.topAnchor.constraint(equalTo: alreadyHaveAccountView.topAnchor),
            loginButton.leadingAnchor.constraint(equalTo: alreadyHaveAccountLabel.trailingAnchor, constant: 4),
            alreadyHaveAccountLabel.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
            
            continueAsGuestView.topAnchor.constraint(equalTo: alreadyHaveAccountView.bottomAnchor, constant: 8),
            continueAsGuestView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueAsGuestView.leadingAnchor.constraint(equalTo: orContinueAsLabel.leadingAnchor),
            continueAsGuestView.trailingAnchor.constraint(equalTo: guestButton.trailingAnchor),
            continueAsGuestView.bottomAnchor.constraint(equalTo: guestButton.bottomAnchor),
            guestButton.topAnchor.constraint(equalTo: continueAsGuestView.topAnchor),
            guestButton.leadingAnchor.constraint(equalTo: orContinueAsLabel.trailingAnchor, constant: 4),
            orContinueAsLabel.centerYAnchor.constraint(equalTo: guestButton.centerYAnchor)
        ])
    }
    
    private func createAccount() {
        if isFormValid() {
            guard let name = nameField.text,
                  let email = emailField.text,
                  let password = passwordField.text else { return }
            
            Task {
                do {
                    try await DataManager.shared.registerUser(name: name, email: email, password: password)
                    // -> navigate to menu
                } catch {
                    handleRegistrationError(error)
                }
            }
        } else {
            // warning "Please fill in all fields"
        }
    }
    
    private func handleRegistrationError(_ error: Error) {
        if let networkError = error as? NetworkLayerError {
            switch networkError {
            case .networkError(let underlyingError):
                // warning - "Network connection error. Please try again later."
                print(underlyingError.localizedDescription)
            case .authenticationFailed:
                // warning - "Registration failed. Please check your credentials and try again."
                print(error)
            case .firestoreDataWasNotReceived(let firestoreError):
                // warning - "Failed to receive data from server. Please try again later."
                print(firestoreError.localizedDescription)
            default:
                // warning - "An unknown error occurred. Please try again later."
                print(error)
            }
        } else {
            // warning - "An unknown error occurred. Please try again later."
        }
    }
    
    private func isFormValid() -> Bool {
        var isValid = true
        
        if emailField.text?.isEmpty ?? true {
            emailField.isInWarning = true
            isValid = false
        } else if !isValidEmail(emailField.text!) {
            emailField.isInWarning = true
            isValid = false
        } else {
            emailField.isInWarning = false
        }
        
        if passwordField.text?.isEmpty ?? true {
            passwordField.isInWarning = true
            isValid = false
        } else if passwordField.text!.count < 6 {
            passwordField.isInWarning = true
            isValid = false
        } else {
            passwordField.isInWarning = false
        }
        
        if confirmPasswordField.text?.isEmpty ?? true {
            confirmPasswordField.isInWarning = true
            isValid = false
        } else if passwordField.text != confirmPasswordField.text {
            confirmPasswordField.isInWarning = true
            isValid = false
        } else {
            confirmPasswordField.isInWarning = false
        }
        
        return isValid
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    // MARK: - Objc methods
    
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
    private func guestButtonTapped() {
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
        if textField == nameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            confirmPasswordField.becomeFirstResponder()
        } else if textField == confirmPasswordField {
            textField.resignFirstResponder()
            createAccount()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let field = textField as? TextField {
            field.isInWarning = false
        }
    }
    
}
