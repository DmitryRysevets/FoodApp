//
//  DeliveryAddressVC.swift
//  FoodApp
//

import UIKit
import GoogleMaps
import GooglePlaces

final class DeliveryAddressVC: UIViewController, CLLocationManagerDelegate {
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()

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
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 14, axis: [Constants.fontWeightAxis : 550])
        label.text = "Adress"
        return label
    }()

    private lazy var addressField: TextField = {
        let field = TextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = ColorManager.shared.payment_fieldColor
        field.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [Constants.fontWeightAxis : 600])
        field.textColor = ColorManager.shared.label
        field.tintColor = ColorManager.shared.orange
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.background
        
        view.addSubview(headerView)
        view.addSubview(addressLabel)
        view.addSubview(addressField)
        view.addSubview(geolocationButton)
        view.addSubview(mapSectionView)
        view.addSubview(okButton)

        headerView.addSubview(backButton)
        headerView.addSubview(deliveryAddressTitleLabel)
        
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
            
            addressLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            addressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            addressField.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8),
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
            mapView.topAnchor.constraint(equalTo: mapSectionView.topAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: mapSectionView.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: mapSectionView.trailingAnchor, constant: -16),
            mapView.bottomAnchor.constraint(equalTo: mapSectionView.bottomAnchor, constant: -16),
            
            okButton.heightAnchor.constraint(equalToConstant: Constants.regularButtonHeight),
            okButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            okButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            okButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16)
        ])
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
    
    // MARK: - Location manager methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15.0)
            mapView.animate(to: camera)
            
            let marker = GMSMarker()
            marker.position = location.coordinate
            marker.map = mapView
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else if status == .denied {
            // Need a handler for a denied case
        }
    }
    
}

