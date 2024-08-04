//
//  DeliveryAddressVC.swift
//  FoodApp
//

import UIKit
import GoogleMaps

final class AddressVC: UIViewController {
        
    private var location: CLLocation? {
        didSet {
            updateMapView()
        }
    }
    
    private var needToUpdateCoreData = false
    private var oldPlaceName = ""
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    // MARK: - UI props.
    
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
    
    private lazy var pageTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 21, axis: [Constants.fontWeightAxis : 650])
        label.textAlignment = .center
        label.text = "New Address"
        return label
    }()
    
    private lazy var geolocationButton: UIButton = {
        let image = UIImage(named: "Pin")
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 22
        button.backgroundColor = ColorManager.shared.label.withAlphaComponent(0.1)
        button.tintColor = ColorManager.shared.label
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(geolocationButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(geolocationButtonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        return button
    }()
    
    private lazy var placeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 550])
        label.text = "Place Name"
        return label
    }()
    
    private lazy var placeNameField: TextField = {
        let field = TextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.returnKeyType = .next
        field.delegate = self
        return field
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 550])
        label.text = "Address"
        return label
    }()
    
    private lazy var addressField: TextField = {
        let field = TextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.returnKeyType = .next
        field.delegate = self
        return field
    }()
    
    private lazy var mapSectionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorManager.shared.payment_mapViewColor
        view.layer.cornerRadius = 24
        return view
    }()
    
    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: 41.6903308028158, longitude: 44.807368755121445, zoom: 17.0)
        let mapView = GMSMapView()
        mapView.camera = camera
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = 14
        return mapView
    }()
    
    private lazy var marker: GMSMarker = {
        let marker = GMSMarker()
        if let customIcon = UIImage(named: "GooglePin") {
            marker.icon = customIcon
        }
        return marker
    }()
    
    private lazy var defaultAddressCheckBox: CheckBox = {
        let checkbox = CheckBox()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.addTarget(self, action: #selector(defaultAddressCheckBoxDidTapped), for: .touchUpInside)
        checkbox.isChecked = false
        return checkbox
    }()
    
    private lazy var defaultAddressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 550])
        label.text = "Use this address by default"
        label.numberOfLines = 2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(defaultAddressCheckBoxDidTapped))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.regularButtonHeight / 2
        button.backgroundColor = ColorManager.shared.regularButtonColor
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.6), for: .highlighted)
        button.titleLabel?.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [Constants.fontWeightAxis : 550])
        button.addTarget(self, action: #selector(saveButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(saveButtonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        return button
    }()
    
    // MARK: - Controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        applyMapStyle(for: mapView)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            applyMapStyle(for: mapView)
        }
    }
    
    // MARK: - internal methods
    
    func configureWithExisting(_ adress: AddressEntity) {
        needToUpdateCoreData = true
        defaultAddressCheckBox.isHidden = true
        defaultAddressLabel.isHidden = true
        oldPlaceName = adress.placeName!
        pageTitleLabel.text = "Address"
        placeNameField.text = adress.placeName
        addressField.text = adress.address
        location = CLLocation(latitude: adress.latitude, longitude: adress.longitude)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.background
        
        view.addSubview(headerView)
        view.addSubview(placeNameLabel)
        view.addSubview(placeNameField)
        view.addSubview(addressLabel)
        view.addSubview(addressField)
        view.addSubview(mapSectionView)
        view.addSubview(geolocationButton)
        view.addSubview(defaultAddressCheckBox)
        view.addSubview(defaultAddressLabel)
        view.addSubview(saveButton)
        
        headerView.addSubview(backButton)
        headerView.addSubview(pageTitleLabel)
        
        mapSectionView.addSubview(mapView)
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
            pageTitleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: -4),
            pageTitleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16),
            pageTitleLabel.trailingAnchor.constraint(equalTo: geolocationButton.leadingAnchor, constant: -16),
            geolocationButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            geolocationButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            geolocationButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
            geolocationButton.widthAnchor.constraint(equalTo: geolocationButton.heightAnchor),
            
            placeNameLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 32),
            placeNameLabel.leadingAnchor.constraint(equalTo: placeNameField.leadingAnchor, constant: 16),
            placeNameField.topAnchor.constraint(equalTo: placeNameLabel.bottomAnchor, constant: 8),
            placeNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            placeNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            placeNameField.heightAnchor.constraint(equalToConstant: Constants.regularFieldHeight),
            
            addressLabel.topAnchor.constraint(equalTo: placeNameField.bottomAnchor, constant: 12),
            addressLabel.leadingAnchor.constraint(equalTo: addressField.leadingAnchor, constant: 16),
            addressField.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8),
            addressField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            addressField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addressField.heightAnchor.constraint(equalToConstant: Constants.regularFieldHeight),
            
            mapSectionView.topAnchor.constraint(equalTo: addressField.bottomAnchor, constant: 32),
            mapSectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mapSectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mapSectionView.heightAnchor.constraint(equalToConstant: 240),
            mapView.topAnchor.constraint(equalTo: mapSectionView.topAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: mapSectionView.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: mapSectionView.trailingAnchor, constant: -16),
            mapView.bottomAnchor.constraint(equalTo: mapSectionView.bottomAnchor, constant: -16),
            
            defaultAddressCheckBox.topAnchor.constraint(equalTo: mapSectionView.bottomAnchor, constant: 32),
            defaultAddressCheckBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            defaultAddressCheckBox.widthAnchor.constraint(equalToConstant: Constants.checkboxSize),
            defaultAddressCheckBox.heightAnchor.constraint(equalToConstant: Constants.checkboxSize),
            defaultAddressLabel.topAnchor.constraint(equalTo: defaultAddressCheckBox.topAnchor),
            defaultAddressLabel.leadingAnchor.constraint(equalTo: defaultAddressCheckBox.trailingAnchor, constant: 8),
            defaultAddressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            saveButton.heightAnchor.constraint(equalToConstant: Constants.regularButtonHeight),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16)
        ])
    }
    
    private func getCoordinatesFrom(_ address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print("Error geocoding address: \(error.localizedDescription)")
                // here the user needs to be notified
            } else if let placemark = placemarks?.first {
                self.location = placemark.location
            }
        }
    }
    
    private func getAddressFrom(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error reverse geocoding: \(error.localizedDescription)")
            } else if let placemark = placemarks?.first {
                if let address = placemark.name {
                    self.addressField.text = address
                }
            }
        }
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
    
    private func isAddressValid() -> Bool {
        if placeNameField.text?.isEmpty ?? true {
            setWarning(for: placeNameField, label: placeNameLabel)
            return false
        }

        if addressField.text?.isEmpty ?? true {
            setWarning(for: addressField, label: addressLabel)
            return false
        }
        
        if location == nil {
            // need warning
            return false
        }
        
        return true
    }
    
    private func setWarning(for field: TextField, label: UILabel) {
        field.isInWarning = true
        label.textColor = ColorManager.shared.warningRed
    }

    private func updateWarning(for field: TextField, label: UILabel) {
        if field.isInWarning {
            field.isInWarning = false
            label.textColor = ColorManager.shared.labelGray
        }
    }
    
    private func applyMapStyle(for mapView: GMSMapView) {
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
    
    // MARK: - ObjC methods
    
    @objc
    private func backButtonTapped() {
        dismiss(animated: true)
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
    private func defaultAddressCheckBoxDidTapped() {
        defaultAddressCheckBox.isChecked.toggle()
    }
    
    @objc
    private func saveButtonTouchDown() {
        UIView.animate(withDuration: 0.05) {
            self.saveButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc
    private func saveButtonTouchUp() {
        UIView.animate(withDuration: 0.05, delay: 0.05, options: [], animations: {
            self.saveButton.transform = CGAffineTransform.identity
        }, completion: nil)
        
        if isAddressValid() {
            guard let location = location else { return }
            
            if needToUpdateCoreData {
                do {
                    try CoreDataManager.shared.updateAddress(oldPlaceName: oldPlaceName,
                                                             newPlaceName: placeNameField.text!,
                                                             address: addressField.text!,
                                                             latitude: location.coordinate.latitude,
                                                             longitude: location.coordinate.longitude)
                    dismiss(animated: true)
                } catch {
                    // need warning
                }
            } else {
                do {
                    try CoreDataManager.shared.saveAddress(placeName: placeNameField.text!,
                                                           address: addressField.text!,
                                                           latitude: location.coordinate.latitude,
                                                           longitude: location.coordinate.longitude,
                                                           isDefaultAddress: defaultAddressCheckBox.isChecked)
                    dismiss(animated: true)
                } catch {
                    // need warning
                }
            }
        }
        
    }
}

// MARK: - CLLocationManagerDelegate

extension AddressVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location
            getAddressFrom(location)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted {
            // Need a handler for a that case
        }
    }
}

// MARK: - UITextFieldDelegate

extension AddressVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == placeNameField {
            addressField.becomeFirstResponder()
        } else if textField == addressField {
            guard let address = textField.text, !address.isEmpty else { return false }
            getCoordinatesFrom(address)
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == placeNameField {
            updateWarning(for: placeNameField, label: placeNameLabel)
        } else if textField == addressField {
            updateWarning(for: addressField, label: addressLabel)
        }
    }
    
}
