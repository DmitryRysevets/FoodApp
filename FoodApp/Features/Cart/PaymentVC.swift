//
//  PaymentVC.swift
//  FoodApp
//

import UIKit
import GoogleMaps

final class PaymentVC: UIViewController {
    
    private let amountDue: Double
    
    private var paymentMethodIsSelected = false
    private var deliveryAddressIsSelected = false
    
    private var location: CLLocation? {
        didSet {
            updateMapView()
        }
    }
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    private lazy var backButtonView: NavigationBarButtonView = {
        let view = NavigationBarButtonView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        view.addGestureRecognizer(tapGesture)
        view.configureAsBackButton()
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Payment method section
    
    private lazy var paymentOptionsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorManager.shared.payment_sectionColor
        view.layer.cornerRadius = 36
        return view
    }()
    
    private lazy var payCashRadioButton: RadioButton = {
        let button = RadioButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(payCashRadioButtonTapped), for: .touchUpInside)
        button.isSelected = false
        return button
    }()
    
    private lazy var payCashLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 550])
        label.text = "Pay cash to the courier"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(payCashRadioButtonTapped))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var payByCardRadioButton: RadioButton = {
        let button = RadioButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(payByCardRadioButtonTapped), for: .touchUpInside)
        button.isSelected = true
        return button
    }()
    
    private lazy var payByCardLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 600])
        label.text = "Pay by card"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(payByCardRadioButtonTapped))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var selectCardView: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToPaymentMethodsTapped))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorManager.shared.payment_secondaryButtonColor
        view.layer.cornerRadius = 22
        return view
    }()

    private lazy var selectCardLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 550])
        label.text = "Add payment card"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var goToPaymentMethodsImageView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = ColorManager.shared.label
        return imageView
    }()
    
    //MARK: - Map section
    
    private lazy var mapSectionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorManager.shared.payment_sectionColor
        view.layer.cornerRadius = 36
        return view
    }()
    
    private lazy var geolocationButton: UIButton = {
        let image = UIImage(named: "Pin")
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 22
        button.backgroundColor = ColorManager.shared.payment_secondaryButtonColor
        button.tintColor = ColorManager.shared.label
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(geolocationButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(geolocationButtonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        return button
    }()
    
    private lazy var selectAddressView: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToDeliveryAddressesTapped))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorManager.shared.payment_secondaryButtonColor
        view.layer.cornerRadius = 22
        return view
    }()
    
    private lazy var selectedAddressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 550])
        label.text = "Add delivery address"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var goToDeliveryAddressesImageView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = ColorManager.shared.label
        return imageView
    }()
    
    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: 41.6903308028158, longitude: 44.807368755121445, zoom: 17.0)
        let mapView = GMSMapView()
        mapView.camera = camera
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = 20
        mapView.layer.borderWidth = 1
        mapView.layer.borderColor = ColorManager.shared.labelGray.withAlphaComponent(0.1).cgColor
        return mapView
    }()
    
    private lazy var marker: GMSMarker = {
        let marker = GMSMarker()
        if let customIcon = UIImage(named: "GooglePin") {
            marker.icon = customIcon
        }
        return marker
    }()
    
    //MARK: - User agreement section

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
    
    //MARK: - Place order section
    
    private lazy var placeOrderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorManager.shared.payment_totalAmountSection
        view.layer.cornerRadius = 36
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
    
    // MARK: - Controller methods
    
    init(amountDue: Double) {
        self.amountDue = amountDue
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupUI()
        setupConstraints()
        applyMapStyle()
        
        payCashRadioButton.alternateButton = [payByCardRadioButton]
        payByCardRadioButton.alternateButton = [payCashRadioButton]
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            applyMapStyle()
        }
    }
    
    //MARK: - Private methods
    
    private func setupNavBar() {
        title = "Payment"
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: ColorManager.shared.label,
            .font: UIFont.getVariableVersion(of: "Raleway", size: 21, axis: [Constants.fontWeightAxis : 650])
        ]
        
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationController?.interactivePopGestureRecognizer?.delegate = self

        let backBarButtonItem = UIBarButtonItem(customView: backButtonView)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.background

        view.addSubview(scrollView)
        
        scrollView.addSubview(paymentOptionsView)
        scrollView.addSubview(mapSectionView)
        scrollView.addSubview(userAgreementCheckBox)
        scrollView.addSubview(userAgreementLabel)
        scrollView.addSubview(placeOrderView)
        
        paymentOptionsView.addSubview(payCashRadioButton)
        paymentOptionsView.addSubview(payCashLabel)
        paymentOptionsView.addSubview(payByCardRadioButton)
        paymentOptionsView.addSubview(payByCardLabel)
        paymentOptionsView.addSubview(selectCardView)
        
        selectCardView.addSubview(selectCardLabel)
        selectCardView.addSubview(goToPaymentMethodsImageView)
        
        mapSectionView.addSubview(geolocationButton)
        mapSectionView.addSubview(selectAddressView)
        mapSectionView.addSubview(mapView)
        
        selectAddressView.addSubview(selectedAddressLabel)
        selectAddressView.addSubview(goToDeliveryAddressesImageView)
        
        placeOrderView.addSubview(totalAmountLabel)
        placeOrderView.addSubview(seePriceDetailsLabel)
        placeOrderView.addSubview(priceLabel)
        placeOrderView.addSubview(placeOrderButton)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            paymentOptionsView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32),
            paymentOptionsView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            paymentOptionsView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            paymentOptionsView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            paymentOptionsView.heightAnchor.constraint(equalToConstant: 172),
            payCashRadioButton.topAnchor.constraint(equalTo: paymentOptionsView.topAnchor, constant: 24),
            payCashRadioButton.leadingAnchor.constraint(equalTo: paymentOptionsView.leadingAnchor, constant: 24),
            payCashRadioButton.heightAnchor.constraint(equalToConstant: 20),
            payCashRadioButton.widthAnchor.constraint(equalToConstant: 20),
            payCashLabel.centerYAnchor.constraint(equalTo: payCashRadioButton.centerYAnchor),
            payCashLabel.leadingAnchor.constraint(equalTo: payCashRadioButton.trailingAnchor, constant: 8),
            payByCardRadioButton.topAnchor.constraint(equalTo: payCashRadioButton.bottomAnchor, constant: 24),
            payByCardRadioButton.leadingAnchor.constraint(equalTo: payCashRadioButton.leadingAnchor),
            payByCardRadioButton.heightAnchor.constraint(equalToConstant: 20),
            payByCardRadioButton.widthAnchor.constraint(equalToConstant: 20),
            payByCardLabel.centerYAnchor.constraint(equalTo: payByCardRadioButton.centerYAnchor),
            payByCardLabel.leadingAnchor.constraint(equalTo: payByCardRadioButton.trailingAnchor, constant: 8),
            selectCardView.leadingAnchor.constraint(equalTo: paymentOptionsView.leadingAnchor, constant: 16),
            selectCardView.trailingAnchor.constraint(equalTo: paymentOptionsView.trailingAnchor, constant: -16),
            selectCardView.bottomAnchor.constraint(equalTo: paymentOptionsView.bottomAnchor, constant: -16),
            selectCardView.heightAnchor.constraint(equalToConstant: 44),
            
            selectCardLabel.centerYAnchor.constraint(equalTo: selectCardView.centerYAnchor),
            selectCardLabel.leadingAnchor.constraint(equalTo: selectCardView.leadingAnchor, constant: 16),
            selectCardLabel.trailingAnchor.constraint(equalTo: goToPaymentMethodsImageView.leadingAnchor, constant: -16),
            goToPaymentMethodsImageView.centerYAnchor.constraint(equalTo: selectCardView.centerYAnchor),
            goToPaymentMethodsImageView.trailingAnchor.constraint(equalTo: selectCardView.trailingAnchor, constant: -12),
            goToPaymentMethodsImageView.heightAnchor.constraint(equalToConstant: 20),
            goToPaymentMethodsImageView.widthAnchor.constraint(equalTo: goToPaymentMethodsImageView.heightAnchor),
            
            mapSectionView.topAnchor.constraint(equalTo: paymentOptionsView.bottomAnchor, constant: 32),
            mapSectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            mapSectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            mapSectionView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            mapSectionView.heightAnchor.constraint(equalToConstant: 280),
            geolocationButton.topAnchor.constraint(equalTo: mapSectionView.topAnchor, constant: 16),
            geolocationButton.leadingAnchor.constraint(equalTo: mapSectionView.leadingAnchor, constant: 16),
            geolocationButton.heightAnchor.constraint(equalToConstant: 44),
            geolocationButton.widthAnchor.constraint(equalTo: geolocationButton.heightAnchor),
            selectAddressView.topAnchor.constraint(equalTo: mapSectionView.topAnchor, constant: 16),
            selectAddressView.leadingAnchor.constraint(equalTo: geolocationButton.trailingAnchor, constant: 12),
            selectAddressView.trailingAnchor.constraint(equalTo: mapSectionView.trailingAnchor, constant: -16),
            selectAddressView.heightAnchor.constraint(equalToConstant: 44),
            mapView.topAnchor.constraint(equalTo: geolocationButton.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: mapSectionView.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: mapSectionView.trailingAnchor, constant: -16),
            mapView.bottomAnchor.constraint(equalTo: mapSectionView.bottomAnchor, constant: -16),
            
            selectedAddressLabel.centerYAnchor.constraint(equalTo: selectAddressView.centerYAnchor),
            selectedAddressLabel.leadingAnchor.constraint(equalTo: selectAddressView.leadingAnchor, constant: 16),
            selectedAddressLabel.trailingAnchor.constraint(equalTo: goToDeliveryAddressesImageView.leadingAnchor, constant: -16),
            goToDeliveryAddressesImageView.centerYAnchor.constraint(equalTo: selectAddressView.centerYAnchor),
            goToDeliveryAddressesImageView.trailingAnchor.constraint(equalTo: selectAddressView.trailingAnchor, constant: -12),
            goToDeliveryAddressesImageView.heightAnchor.constraint(equalToConstant: 20),
            goToDeliveryAddressesImageView.widthAnchor.constraint(equalTo: goToDeliveryAddressesImageView.heightAnchor),
            
            userAgreementCheckBox.topAnchor.constraint(equalTo: mapSectionView.bottomAnchor, constant: 32),
            userAgreementCheckBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            userAgreementCheckBox.widthAnchor.constraint(equalToConstant: Constants.checkboxSize),
            userAgreementCheckBox.heightAnchor.constraint(equalToConstant: Constants.checkboxSize),
            userAgreementLabel.topAnchor.constraint(equalTo: userAgreementCheckBox.topAnchor, constant: -4),
            userAgreementLabel.leadingAnchor.constraint(equalTo: userAgreementCheckBox.trailingAnchor, constant: 8),
            userAgreementLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            placeOrderView.topAnchor.constraint(equalTo: userAgreementCheckBox.bottomAnchor, constant: 52),
            placeOrderView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            placeOrderView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            placeOrderView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            placeOrderView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -32),
            totalAmountLabel.topAnchor.constraint(equalTo: placeOrderView.topAnchor, constant: 24),
            totalAmountLabel.leadingAnchor.constraint(equalTo: placeOrderView.leadingAnchor, constant: 24),
            seePriceDetailsLabel.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor, constant: 3),
            seePriceDetailsLabel.leadingAnchor.constraint(equalTo: placeOrderView.leadingAnchor, constant: 24),
            priceLabel.topAnchor.constraint(equalTo: placeOrderView.topAnchor, constant: 30),
            priceLabel.trailingAnchor.constraint(equalTo: placeOrderView.trailingAnchor, constant: -24),
            placeOrderButton.topAnchor.constraint(equalTo: seePriceDetailsLabel.bottomAnchor, constant: 28),
            placeOrderButton.leadingAnchor.constraint(equalTo: placeOrderView.leadingAnchor, constant: 16),
            placeOrderButton.trailingAnchor.constraint(equalTo: placeOrderView.trailingAnchor, constant: -16),
            placeOrderButton.bottomAnchor.constraint(equalTo: placeOrderView.bottomAnchor, constant: -16),
            placeOrderButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func updateMapView() {
        if let location = location {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
            mapView.moveCamera(GMSCameraUpdate.setCamera(camera))
            marker.map = mapView
            marker.position = location.coordinate
        }
    }
    
    private func getAddressFrom(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                self.selectedAddressLabel.text = "Your geolocation"
            } else if let placemark = placemarks?.first {
                if let address = placemark.name {
                    self.selectedAddressLabel.text = address
                }
            }
        }
    }
    
    private func applyMapStyle() {
        let userInterfaceStyle = UITraitCollection.current.userInterfaceStyle
        let styleFileName: String

        switch userInterfaceStyle {
        case .dark:
            styleFileName = "map_dark_style"
        default:
            styleFileName = "map_light_style"
        }

        if let styleURL = Bundle.main.url(forResource: styleFileName, withExtension: "json") {
            do {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } catch {
                print("Failed to load map style. \(error)")
            }
        }
    }
    
    //MARK: - Objc methods
    
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func payCashRadioButtonTapped() {
        payCashRadioButton.isSelected = true
        payCashRadioButton.unselectAlternateButtons()
    }
    
    @objc
    private func payByCardRadioButtonTapped() {
        payByCardRadioButton.isSelected = true
        payByCardRadioButton.unselectAlternateButtons()
    }
    
    @objc
    private func geolocationButtonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.geolocationButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    @objc
    private func geolocationButtonTouchUp() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: [], animations: {
            self.geolocationButton.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    @objc
    private func goToPaymentMethodsTapped() {
        navigationController?.pushViewController(PaymentMethodsVC(), animated: true)
    }
    
    @objc
    private func goToDeliveryAddressesTapped() {
        navigationController?.pushViewController(DeliveryAddressesVC(), animated: true)
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

// MARK: - UIGestureRecognizerDelegate

extension PaymentVC: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}

// MARK: - CLLocationManagerDelegate

extension PaymentVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location
            getAddressFrom(location)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted {
            print("trouble with geolocation - \(status)")
            // Need a handler for a that case
        }
    }
}
