//
//  DeliveryAddressVC.swift
//  FoodApp
//

import UIKit
import GoogleMaps

final class DeliveryAddressVC: UIViewController {
    
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

    private lazy var deliveryAddressTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 21, axis: [Constants.fontWeightAxis : 650])
        label.text = "Delivery Address"
        return label
    }()
    
    private lazy var addressField: TextField = {
        let field = TextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Enter the address"
        field.delegate = self
        return field
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
    
    private lazy var mapSectionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorManager.shared.payment_mapViewColor
        view.layer.cornerRadius = 24
        return view
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 600])
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Delivery Address"
        return label
    }()

    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: 41.6903308028158, longitude: 44.807368755121445, zoom: 17.0)
        let mapView = GMSMapView()
        mapView.camera = camera
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = 14
        return mapView
    }()
    
    private lazy var okButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.regularButtonHeight / 2
        button.backgroundColor = ColorManager.shared.regularButtonColor
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.6), for: .highlighted)
        button.titleLabel?.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [Constants.fontWeightAxis : 550])
        button.addTarget(self, action: #selector(okButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(okButtonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        return button
    }()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.background
        
        view.addSubview(headerView)
        view.addSubview(addressField)
        view.addSubview(geolocationButton)
        view.addSubview(mapSectionView)
        view.addSubview(okButton)

        headerView.addSubview(backButton)
        headerView.addSubview(deliveryAddressTitleLabel)
        
        mapSectionView.addSubview(locationLabel)
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
            deliveryAddressTitleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: -4),
            deliveryAddressTitleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            deliveryAddressTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            addressField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 32),
            addressField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addressField.trailingAnchor.constraint(equalTo: geolocationButton.leadingAnchor, constant: -12),
            addressField.heightAnchor.constraint(equalToConstant: Constants.regularFieldHeight),
            
            geolocationButton.centerYAnchor.constraint(equalTo: addressField.centerYAnchor),
            geolocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            geolocationButton.heightAnchor.constraint(equalToConstant: Constants.regularFieldHeight),
            geolocationButton.widthAnchor.constraint(equalTo: geolocationButton.heightAnchor),
            
            mapSectionView.topAnchor.constraint(equalTo: addressField.bottomAnchor, constant: 32),
            mapSectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mapSectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mapSectionView.heightAnchor.constraint(equalToConstant: 300),
            locationLabel.topAnchor.constraint(equalTo: mapSectionView.topAnchor, constant: 16),
            locationLabel.leadingAnchor.constraint(equalTo: mapSectionView.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: mapSectionView.trailingAnchor, constant: -16),
            mapView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: mapSectionView.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: mapSectionView.trailingAnchor, constant: -16),
            mapView.bottomAnchor.constraint(equalTo: mapSectionView.bottomAnchor, constant: -16),
            
            okButton.heightAnchor.constraint(equalToConstant: Constants.regularButtonHeight),
            okButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            okButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            okButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16)
        ])
    }
    
    private func getAddressFrom(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error reverse geocoding: \(error.localizedDescription)")
            } else if let placemark = placemarks?.first {
                if let address = placemark.name {
                    self.locationLabel.text = address
                }
            }
        }
    }
    
    private func getCoordinatesFrom(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print("Error geocoding address: \(error.localizedDescription)")
            } else if let placemark = placemarks?.first, let location = placemark.location {
                self.updateMapView(with: location.coordinate, address: address)
            }
        }
    }
    
    private func updateMapView(with coordinate: CLLocationCoordinate2D, address: String) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15.0)
        mapView.animate(to: camera)
        
        let marker = GMSMarker()
        marker.position = coordinate
        marker.map = mapView
        
        locationLabel.text = address
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
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: [], animations: {
            self.geolocationButton.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    @objc
    private func okButtonTouchDown() {
        UIView.animate(withDuration: 0.05) {
            self.okButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc
    private func okButtonTouchUp() {
        UIView.animate(withDuration: 0.05, delay: 0.05, options: [], animations: {
            self.okButton.transform = CGAffineTransform.identity
        }, completion: nil)
        dismiss(animated: true)
    }
}

// MARK: - CLLocationManagerDelegate

extension DeliveryAddressVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15.0)
            mapView.animate(to: camera)
            
            let marker = GMSMarker()
            marker.position = location.coordinate
            marker.map = mapView
            
            getAddressFrom(location: location)
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else if status == .denied || status == .restricted {
            // Need a handler for a that case
        }
    }
}

// MARK: - UITextFieldDelegate

extension DeliveryAddressVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let address = textField.text, !address.isEmpty else { return false }
        getCoordinatesFrom(address: address)
        textField.resignFirstResponder()
        textField.text = ""
        return true
    }
}
