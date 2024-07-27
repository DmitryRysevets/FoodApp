//
//  PaymentMethodsVC.swift
//  FoodApp
//

import UIKit

final class PaymentMethodsVC: UIViewController {
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: configuration)?.resized(to: CGSize(width: 12, height: 16)).withTintColor(ColorManager.shared.label)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.tintColor = ColorManager.shared.label
        button.backgroundColor = ColorManager.shared.headerElementsColor
        button.layer.cornerRadius = Constants.headerButtonSize / 2
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var paymentMethodsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 21, axis: [Constants.fontWeightAxis : 650])
        label.text = "New Card"
        return label
    }()
    
    private lazy var cardSectionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorManager.shared.payment_mapViewColor
        view.layer.cornerRadius = 24
        return view
    }()
    
    private lazy var cardNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 550])
        label.text = "Card Name"
        return label
    }()
    
    private lazy var cardNameField: TextField = {
        let field = TextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardType = .numberPad
        field.delegate = self
        return field
    }()
    
    private lazy var cardNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 550])
        label.text = "Card Number"
        return label
    }()
    
    private lazy var cardNumberField: TextField = {
        let field = TextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardType = .numberPad
        field.delegate = self
        return field
    }()
    
    private lazy var mmyyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 550])
        label.text = "MM/YY"
        return label
    }()
    
    private lazy var mmyyField: TextField = {
        let field = TextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardType = .numberPad
        field.delegate = self
        return field
    }()
    
    private lazy var cvcLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 550])
        label.text = "CVC"
        return label
    }()
    
    private lazy var cvcField: TextField = {
        let field = TextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardType = .numberPad
        field.delegate = self
        return field
    }()
    
    private lazy var cardholderNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 550])
        label.text = "Cardholder Name"
        return label
    }()
    
    private lazy var cardholderNameField: TextField = {
        let field = TextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.autocapitalizationType = .allCharacters
        field.delegate = self
        return field
    }()
    
    private lazy var userAgreementCheckBox: CheckBox = {
        let checkbox = CheckBox()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.addTarget(self, action: #selector(userAgreementCheckBoxDidTapped), for: .touchUpInside)
        checkbox.isChecked = false
        return checkbox
    }()
    
    private lazy var userAgreementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 550])
        label.text = "I have read and accept the terms of use, rules of flight and privacy policy"
        label.numberOfLines = 2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userAgreementCheckBoxDidTapped))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var addCardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.regularButtonHeight / 2
        button.backgroundColor = ColorManager.shared.regularButtonColor
        button.setTitle("Add Card", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.6), for: .highlighted)
        button.titleLabel?.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [Constants.fontWeightAxis : 550])
        button.addTarget(self, action: #selector(addCardButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(addCardButtonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        return button
    }()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.background
        
        view.addSubview(headerView)
        view.addSubview(cardNameLabel)
        view.addSubview(cardNameField)
        view.addSubview(cardSectionView)
        view.addSubview(userAgreementCheckBox)
        view.addSubview(userAgreementLabel)
        view.addSubview(addCardButton)

        headerView.addSubview(backButton)
        headerView.addSubview(paymentMethodsTitleLabel)
        
        cardSectionView.addSubview(cardNumberLabel)
        cardSectionView.addSubview(cardNumberField)
        cardSectionView.addSubview(mmyyLabel)
        cardSectionView.addSubview(mmyyField)
        cardSectionView.addSubview(cvcLabel)
        cardSectionView.addSubview(cvcField)
        cardSectionView.addSubview(cardholderNameLabel)
        cardSectionView.addSubview(cardholderNameField)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 52),
            backButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            paymentMethodsTitleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: -4),
            paymentMethodsTitleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            paymentMethodsTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            cardNameLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 32),
            cardNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cardNameField.topAnchor.constraint(equalTo: cardNameLabel.bottomAnchor, constant: 8),
            cardNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cardNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            cardNameField.heightAnchor.constraint(equalToConstant: Constants.regularFieldHeight),
            
            cardSectionView.topAnchor.constraint(equalTo: cardNameField.bottomAnchor, constant: 24),
            cardSectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardSectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardNumberLabel.topAnchor.constraint(equalTo: cardSectionView.topAnchor, constant: 32),
            cardNumberLabel.leadingAnchor.constraint(equalTo: cardSectionView.leadingAnchor, constant: 16),
            cardNumberField.topAnchor.constraint(equalTo: cardNumberLabel.bottomAnchor, constant: 8),
            cardNumberField.leadingAnchor.constraint(equalTo: cardSectionView.leadingAnchor, constant: 16),
            cardNumberField.trailingAnchor.constraint(equalTo: cardSectionView.trailingAnchor, constant: -16),
            cardNumberField.heightAnchor.constraint(equalToConstant: Constants.regularFieldHeight),
            mmyyLabel.topAnchor.constraint(equalTo: cardNumberField.bottomAnchor, constant: 12),
            mmyyLabel.leadingAnchor.constraint(equalTo: cardSectionView.leadingAnchor, constant: 16),
            mmyyField.topAnchor.constraint(equalTo: mmyyLabel.bottomAnchor, constant: 8),
            mmyyField.leadingAnchor.constraint(equalTo: cardSectionView.leadingAnchor, constant: 16),
            mmyyField.heightAnchor.constraint(equalToConstant: Constants.regularFieldHeight),
            mmyyField.widthAnchor.constraint(equalTo: cardSectionView.widthAnchor, multiplier: 0.5, constant: -20),
            cvcField.topAnchor.constraint(equalTo: mmyyField.topAnchor),
            cvcField.leadingAnchor.constraint(equalTo: mmyyField.trailingAnchor, constant: 8),
            cvcField.trailingAnchor.constraint(equalTo: cardSectionView.trailingAnchor, constant: -16),
            cvcField.heightAnchor.constraint(equalToConstant: Constants.regularFieldHeight),
            cvcLabel.topAnchor.constraint(equalTo: mmyyLabel.topAnchor),
            cvcLabel.leadingAnchor.constraint(equalTo: cvcField.leadingAnchor),
            cardholderNameLabel.topAnchor.constraint(equalTo: mmyyField.bottomAnchor, constant: 12),
            cardholderNameLabel.leadingAnchor.constraint(equalTo: cardSectionView.leadingAnchor, constant: 16),
            cardholderNameField.topAnchor.constraint(equalTo: cardholderNameLabel.bottomAnchor, constant: 8),
            cardholderNameField.leadingAnchor.constraint(equalTo: cardSectionView.leadingAnchor, constant: 16),
            cardholderNameField.trailingAnchor.constraint(equalTo: cardSectionView.trailingAnchor, constant: -16),
            cardholderNameField.heightAnchor.constraint(equalToConstant: Constants.regularFieldHeight),
            cardholderNameField.bottomAnchor.constraint(equalTo: cardSectionView.bottomAnchor, constant: -32),
            
            userAgreementCheckBox.topAnchor.constraint(equalTo: cardSectionView.bottomAnchor, constant: 32),
            userAgreementCheckBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userAgreementCheckBox.widthAnchor.constraint(equalToConstant: 20),
            userAgreementCheckBox.heightAnchor.constraint(equalToConstant: 20),
            userAgreementLabel.topAnchor.constraint(equalTo: userAgreementCheckBox.topAnchor, constant: -4),
            userAgreementLabel.leadingAnchor.constraint(equalTo: userAgreementCheckBox.trailingAnchor, constant: 8),
            userAgreementLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addCardButton.heightAnchor.constraint(equalToConstant: Constants.regularButtonHeight),
            addCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addCardButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Objc methods
    
    @objc
    private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    private func userAgreementCheckBoxDidTapped() {
        userAgreementCheckBox.isChecked.toggle()
    }
    
    @objc
    private func addCardButtonTouchDown() {
        UIView.animate(withDuration: 0.05) {
            self.addCardButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc
    private func addCardButtonTouchUp() {
        UIView.animate(withDuration: 0.05, delay: 0.05, options: [], animations: {
            self.addCardButton.transform = CGAffineTransform.identity
        }, completion: nil)
        dismiss(animated: true)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }

}

// MARK: - Text fields methods

extension PaymentMethodsVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == cardNumberField {
            return formatCardNumber(textField: textField, range: range, replacementString: string)
        } else if textField == mmyyField {
            return formatMMYY(textField: textField, range: range, replacementString: string)
        } else if textField == cvcField {
            return formatCVC(textField: textField, range: range, replacementString: string)
        } else if textField == cardholderNameField {
            return formatCardholderName(textField: textField, range: range, replacementString: string)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == cardholderNameField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == cardholderNameField {
            textField.keyboardType = .asciiCapable
            textField.reloadInputViews()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == cardholderNameField {
            textField.text = textField.text?.uppercased()
        }
    }
    
    private func formatCardNumber(textField: UITextField, range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        let formattedString = newString.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        
        let maxLength = 16
        if formattedString.count > maxLength {
            return false
        }
        
        var formattedNumber = ""
        for (index, character) in formattedString.enumerated() {
            if index % 4 == 0 && index > 0 {
                formattedNumber.append(" ")
            }
            formattedNumber.append(character)
        }
        
        textField.text = formattedNumber
        if formattedString.count == maxLength {
            mmyyField.becomeFirstResponder()
        }
        return false
    }
    
    private func formatMMYY(textField: UITextField, range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        let formattedString = newString.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        
        let maxLength = 4
        if formattedString.count > maxLength {
            return false
        }
        
        var formattedDate = ""
        for (index, character) in formattedString.enumerated() {
            if index == 2 {
                formattedDate.append("/")
            }
            formattedDate.append(character)
        }
        
        textField.text = formattedDate
        if formattedString.count == maxLength {
            cvcField.becomeFirstResponder()
        }
        return false
    }
    
    private func formatCVC(textField: UITextField, range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        let formattedString = newString.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        
        let maxLength = 3
        if formattedString.count > maxLength {
            return false
        }
        
        textField.text = formattedString
        if formattedString.count == maxLength {
            cardholderNameField.becomeFirstResponder()
        }
        return false
    }
    
    private func formatCardholderName(textField: UITextField, range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.letters.union(.whitespaces)
        if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return false
        }
        return true
    }
}
