//
//  PaymentVC.swift
//  FoodApp
//

import UIKit

final class PaymentVC: UIViewController {
    
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
        button.addTarget(self, action: #selector(byPayPalButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var paymentByPayPalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 580])
        return label
    }()
    
    private lazy var payPalImageView: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Payment by card props.
    
    private lazy var radioButtonPaymentByCard: RadioButton = {
        let button = RadioButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(byCardButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var paymentByCardLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 650])
        return label
    }()
    
    private lazy var cardImageViewsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    private lazy var visaImageView: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var mastercardImageView: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var discoverImageView: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 600])
        return label
    }()
    
    private lazy var cardholderNameField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = ColorManager.shared.payment_fieldColor
        field.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [Constants.fontWeightAxis : 600])
        field.textColor = ColorManager.shared.label
        field.tintColor = ColorManager.shared.orange
        return field
    }()
    
    private lazy var mmyyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 600])
        return label
    }()
    
    private lazy var mmyyField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = ColorManager.shared.payment_fieldColor
        field.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [Constants.fontWeightAxis : 600])
        field.textColor = ColorManager.shared.label
        field.tintColor = ColorManager.shared.orange
        return field
    }()
    
    private lazy var cvcLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 600])
        return label
    }()
    
    private lazy var cvcField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = ColorManager.shared.payment_fieldColor
        field.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [Constants.fontWeightAxis : 600])
        field.textColor = ColorManager.shared.label
        field.tintColor = ColorManager.shared.orange
        return field
    }()
    
    private lazy var userAgreementCheckBox: CheckBox = {
        let checkbox = CheckBox()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()
    
    private lazy var userAgreementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 600])
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
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 650])
        return label
    }()
    
    // insert map frame
    
    //MARK: - Place order props.
    
    private lazy var placeOrderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorManager.shared.payment_mapViewColor
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
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 650])
        label.text = "Total Amount"
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 20, axis: [Constants.fontWeightAxis : 650])
        label.text = "$19.68"
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
        button.addTarget(self, action: #selector(placeOrderButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
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
        paymentOptionsView.addSubview(cardImageViewsStack)
        
        cardImageViewsStack.addArrangedSubview(visaImageView)
        cardImageViewsStack.addArrangedSubview(mastercardImageView)
        cardImageViewsStack.addArrangedSubview(discoverImageView)

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
            
            cardDetailsView.topAnchor.constraint(equalTo: paymentOptionsView.topAnchor),
            cardDetailsView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            cardDetailsView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            cardDetailsView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            mapView.topAnchor.constraint(equalTo: cardDetailsView.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mapView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            placeOrderView.topAnchor.constraint(equalTo: cardDetailsView.topAnchor),
            placeOrderView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            placeOrderView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            placeOrderView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            placeOrderView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
            
        ])
    }
    
    //MARK: - Objc methods
    
    @objc
    private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    private func byPayPalButtonDidTapped() {
        
    }
    
    @objc
    private func byCardButtonDidTapped() {
        
    }

    @objc
    private func placeOrderButtonTapped() {
        
    }
}
