//
//  PaymentVC.swift
//  FoodApp
//

import UIKit

final class PaymentVC: UIViewController {
    
    private let amountDue: Double
    
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
    
    private lazy var paymentTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 21, axis: [Constants.fontWeightAxis : 650])
        label.text = "Payment"
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var paymentOptionsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Payment by PayPal props.
    
    private lazy var radioButtonPaymentByPayPal: RadioButton = {
        let button = RadioButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(byPayPalButtonDidTapped), for: .touchUpInside)
        button.isSelected = false
        return button
    }()
    
    private lazy var paymentByPayPalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 550])
        label.text = "Pay With"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(byPayPalButtonDidTapped))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var payPalImageView: UIImageView = {
        let image = UIImage(named: "PayPal")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: - Payment by card props.
    
    private lazy var radioButtonPaymentByCard: RadioButton = {
        let button = RadioButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(byCardButtonDidTapped), for: .touchUpInside)
        button.isSelected = true
        return button
    }()
    
    private lazy var paymentByCardLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 600])
        label.text = "Credit & Debit Card"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(byCardButtonDidTapped))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var typeCardsImageView: UIImageView = {
        let image = UIImage(named: "Cards")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: - Card details props.
    
    private lazy var cardDetailsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        return field
    }()
    
    private lazy var userAgreementCheckBox: CheckBox = {
        let checkbox = CheckBox()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.layer.cornerRadius = 5
        checkbox.layer.borderWidth = 1
        checkbox.layer.borderColor = ColorManager.shared.labelGray.cgColor
        checkbox.backgroundColor = ColorManager.shared.background
        checkbox.tintColor = ColorManager.shared.orange
        checkbox.addTarget(self, action: #selector(userAgreementCheckBoxDidTapped), for: .touchUpInside)
        checkbox.isChecked = false
        return checkbox
    }()
    
    private lazy var userAgreementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 550])
        label.text = "I habe read and accept the terms of use, rules of flight and privacy policy"
        label.numberOfLines = 2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userAgreementCheckBoxDidTapped))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    //MARK: - Map props.
    
    private lazy var mapView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorManager.shared.payment_mapViewColor
        view.layer.cornerRadius = 24
        return view
    }()
    
    private lazy var mapPinImageView: UIImageView = {
        let image = UIImage(named: "Pin")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = ColorManager.shared.label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var deliveryAddressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 600])
        label.text = "Delivery Address"
        return label
    }()
    
    // insert map frame
    
    //MARK: - Place order props.
    
    private lazy var placeOrderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorManager.shared.payment_orderViewColor
        view.layer.cornerRadius = 24
        return view
    }()
    
    private lazy var totalAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 650])
        label.text = "Total Amount"
        return label
    }()
    
    private lazy var seePriceDetailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 13, axis: [Constants.fontWeightAxis : 550])
        label.text = "See price details"
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = "$\(String(format: "%.2f", amountDue))"
        return label
    }()
    
    private lazy var placeOrderButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ColorManager.shared.payment_placeOrderButtonColor
        button.layer.cornerRadius = 26
        button.setTitle("Place Order", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.6), for: .highlighted)
        button.titleLabel?.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [Constants.fontWeightAxis : 550])
        button.addTarget(self, action: #selector(placeOrderButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(placeOrderButtonTouchUp), for: [.touchUpInside, .touchUpOutside])
        return button
    }()
    
    //MARK: - Life cycles methods
    
    init(amountDue: Double) {
        self.amountDue = amountDue
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
        radioButtonPaymentByPayPal.alternateButton = [radioButtonPaymentByCard]
        radioButtonPaymentByCard.alternateButton = [radioButtonPaymentByPayPal]
    }
    
    //MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.background

        view.addSubview(headerView)
        view.addSubview(scrollView)

        headerView.addSubview(backButton)
        headerView.addSubview(paymentTitleLabel)
        
        scrollView.addSubview(paymentOptionsView)
        scrollView.addSubview(cardDetailsView)
        scrollView.addSubview(mapView)
        scrollView.addSubview(placeOrderView)
        
        paymentOptionsView.addSubview(radioButtonPaymentByPayPal)
        paymentOptionsView.addSubview(paymentByPayPalLabel)
        paymentOptionsView.addSubview(payPalImageView)
        paymentOptionsView.addSubview(radioButtonPaymentByCard)
        paymentOptionsView.addSubview(paymentByCardLabel)
        paymentOptionsView.addSubview(typeCardsImageView)

        cardDetailsView.addSubview(cardholderNameLabel)
        cardDetailsView.addSubview(cardholderNameField)
        cardDetailsView.addSubview(mmyyLabel)
        cardDetailsView.addSubview(mmyyField)
        cardDetailsView.addSubview(cvcLabel)
        cardDetailsView.addSubview(cvcField)
        cardDetailsView.addSubview(userAgreementCheckBox)
        cardDetailsView.addSubview(userAgreementLabel)
        
        mapView.addSubview(mapPinImageView)
        mapView.addSubview(deliveryAddressLabel)
        
        placeOrderView.addSubview(totalAmountLabel)
        placeOrderView.addSubview(seePriceDetailsLabel)
        placeOrderView.addSubview(priceLabel)
        placeOrderView.addSubview(placeOrderButton)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Constants.headerHeight),
            backButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            paymentTitleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: -4),
            paymentTitleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            paymentTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            paymentOptionsView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            paymentOptionsView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            paymentOptionsView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            paymentOptionsView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            radioButtonPaymentByPayPal.topAnchor.constraint(equalTo: paymentOptionsView.topAnchor, constant: 24),
            radioButtonPaymentByPayPal.leadingAnchor.constraint(equalTo: paymentOptionsView.leadingAnchor, constant: 16),
            radioButtonPaymentByPayPal.heightAnchor.constraint(equalToConstant: 20),
            radioButtonPaymentByPayPal.widthAnchor.constraint(equalToConstant: 20),
            paymentByPayPalLabel.centerYAnchor.constraint(equalTo: radioButtonPaymentByPayPal.centerYAnchor),
            paymentByPayPalLabel.leadingAnchor.constraint(equalTo: radioButtonPaymentByPayPal.trailingAnchor, constant: 8),
            payPalImageView.centerYAnchor.constraint(equalTo: radioButtonPaymentByPayPal.centerYAnchor),
            payPalImageView.leadingAnchor.constraint(equalTo: paymentByPayPalLabel.trailingAnchor, constant: 8),
            payPalImageView.heightAnchor.constraint(equalToConstant: 28),
            payPalImageView.widthAnchor.constraint(equalTo: payPalImageView.heightAnchor, multiplier: 3.8),
            radioButtonPaymentByCard.topAnchor.constraint(equalTo: radioButtonPaymentByPayPal.bottomAnchor, constant: 24),
            radioButtonPaymentByCard.leadingAnchor.constraint(equalTo: radioButtonPaymentByPayPal.leadingAnchor),
            radioButtonPaymentByCard.heightAnchor.constraint(equalToConstant: 20),
            radioButtonPaymentByCard.widthAnchor.constraint(equalToConstant: 20),
            radioButtonPaymentByCard.bottomAnchor.constraint(equalTo: paymentOptionsView.bottomAnchor, constant: -8),
            paymentByCardLabel.centerYAnchor.constraint(equalTo: radioButtonPaymentByCard.centerYAnchor),
            paymentByCardLabel.leadingAnchor.constraint(equalTo: radioButtonPaymentByCard.trailingAnchor, constant: 8),
            typeCardsImageView.centerYAnchor.constraint(equalTo: radioButtonPaymentByCard.centerYAnchor),
            typeCardsImageView.leadingAnchor.constraint(equalTo: paymentByCardLabel.trailingAnchor, constant: 24),
            typeCardsImageView.heightAnchor.constraint(equalToConstant: 28),
            typeCardsImageView.widthAnchor.constraint(equalTo: typeCardsImageView.heightAnchor, multiplier: 4.72),
            
            cardDetailsView.topAnchor.constraint(equalTo: paymentOptionsView.bottomAnchor),
            cardDetailsView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            cardDetailsView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            cardDetailsView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            cardholderNameLabel.topAnchor.constraint(equalTo: cardDetailsView.topAnchor, constant: 8),
            cardholderNameLabel.leadingAnchor.constraint(equalTo: cardDetailsView.leadingAnchor, constant: 16),
            cardholderNameField.topAnchor.constraint(equalTo: cardholderNameLabel.bottomAnchor, constant: 8),
            cardholderNameField.leadingAnchor.constraint(equalTo: cardDetailsView.leadingAnchor, constant: 16),
            cardholderNameField.trailingAnchor.constraint(equalTo: cardDetailsView.trailingAnchor, constant: -16),
            cardholderNameField.heightAnchor.constraint(equalToConstant: Constants.regularFieldHeight),
            mmyyLabel.topAnchor.constraint(equalTo: cardholderNameField.bottomAnchor, constant: 12),
            mmyyLabel.leadingAnchor.constraint(equalTo: cardDetailsView.leadingAnchor, constant: 16),
            mmyyField.topAnchor.constraint(equalTo: mmyyLabel.bottomAnchor, constant: 8),
            mmyyField.leadingAnchor.constraint(equalTo: cardDetailsView.leadingAnchor, constant: 16),
            mmyyField.heightAnchor.constraint(equalToConstant: Constants.regularFieldHeight),
            mmyyField.widthAnchor.constraint(equalTo: cardDetailsView.widthAnchor, multiplier: 0.5, constant: -20),
            cvcField.topAnchor.constraint(equalTo: mmyyField.topAnchor),
            cvcField.leadingAnchor.constraint(equalTo: mmyyField.trailingAnchor, constant: 8),
            cvcField.trailingAnchor.constraint(equalTo: cardDetailsView.trailingAnchor, constant: -16),
            cvcField.heightAnchor.constraint(equalToConstant: Constants.regularFieldHeight),
            cvcLabel.topAnchor.constraint(equalTo: mmyyLabel.topAnchor),
            cvcLabel.leadingAnchor.constraint(equalTo: cvcField.leadingAnchor),
            userAgreementCheckBox.topAnchor.constraint(equalTo: mmyyField.bottomAnchor, constant: 16),
            userAgreementCheckBox.leadingAnchor.constraint(equalTo: cardDetailsView.leadingAnchor, constant: 16),
            userAgreementCheckBox.widthAnchor.constraint(equalToConstant: Constants.checkboxSize),
            userAgreementCheckBox.heightAnchor.constraint(equalToConstant: Constants.checkboxSize),
            userAgreementLabel.topAnchor.constraint(equalTo: userAgreementCheckBox.topAnchor, constant: -4),
            userAgreementLabel.leadingAnchor.constraint(equalTo: userAgreementCheckBox.trailingAnchor, constant: 8),
            userAgreementLabel.trailingAnchor.constraint(equalTo: cardDetailsView.trailingAnchor, constant: -16),
            userAgreementLabel.bottomAnchor.constraint(equalTo: cardDetailsView.bottomAnchor, constant: -8),
            
            mapView.topAnchor.constraint(equalTo: cardDetailsView.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            mapView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            mapView.heightAnchor.constraint(equalToConstant: 168), // for test
            mapPinImageView.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 16),
            mapPinImageView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 16),
            mapPinImageView.heightAnchor.constraint(equalToConstant: 20),
            mapPinImageView.widthAnchor.constraint(equalToConstant: 20),
            deliveryAddressLabel.centerYAnchor.constraint(equalTo: mapPinImageView.centerYAnchor),
            deliveryAddressLabel.leadingAnchor.constraint(equalTo: mapPinImageView.trailingAnchor, constant: 8),
            
            placeOrderView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 60),
            placeOrderView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            placeOrderView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            placeOrderView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            placeOrderView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -32),
            totalAmountLabel.topAnchor.constraint(equalTo: placeOrderView.topAnchor, constant: 24),
            totalAmountLabel.leadingAnchor.constraint(equalTo: placeOrderView.leadingAnchor, constant: 16),
            seePriceDetailsLabel.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor, constant: 3),
            seePriceDetailsLabel.leadingAnchor.constraint(equalTo: placeOrderView.leadingAnchor, constant: 16),
            priceLabel.topAnchor.constraint(equalTo: placeOrderView.topAnchor, constant: 30),
            priceLabel.trailingAnchor.constraint(equalTo: placeOrderView.trailingAnchor, constant: -16),
            placeOrderButton.topAnchor.constraint(equalTo: seePriceDetailsLabel.bottomAnchor, constant: 14),
            placeOrderButton.leadingAnchor.constraint(equalTo: placeOrderView.leadingAnchor, constant: 16),
            placeOrderButton.trailingAnchor.constraint(equalTo: placeOrderView.trailingAnchor, constant: -16),
            placeOrderButton.bottomAnchor.constraint(equalTo: placeOrderView.bottomAnchor, constant: -16),
            placeOrderButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    //MARK: - Objc methods
    
    @objc
    private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    private func byPayPalButtonDidTapped() {
        radioButtonPaymentByPayPal.isSelected = true
        radioButtonPaymentByPayPal.unselectAlternateButtons()
    }
    
    @objc
    private func byCardButtonDidTapped() {
        radioButtonPaymentByCard.isSelected = true
        radioButtonPaymentByCard.unselectAlternateButtons()
    }
    
    @objc
    private func userAgreementCheckBoxDidTapped() {
        userAgreementCheckBox.isChecked.toggle()
    }
    
    @objc
    private func placeOrderButtonTouchDown() {
        UIView.animate(withDuration: 0.05) {
            self.placeOrderButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc
    private func placeOrderButtonTouchUp() {
        UIView.animate(withDuration: 0.05, delay: 0.05, options: [], animations: {
            self.placeOrderButton.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
