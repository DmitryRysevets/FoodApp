//
//  DeliveryAddressCell.swift
//  FoodApp
//

import UIKit

class DeliveryAddressCell: UITableViewCell {

    static let id = "DeliveryAddressCell"
    
    var addressName: String! {
        didSet {
            addressNameLabel.text = addressName
            setupUI()
        }
    }
    
    var goToAddressHandler: (() -> Void)!
    
    var isPreferredAdress: Bool = false {
        didSet {
            if isPreferredAdress {
                isPreferredAdressCheckBox.isChecked = true
            } else {
                isPreferredAdressCheckBox.isChecked = false
            }
        }
    }
    
    private lazy var isPreferredAdressCheckBox: CheckBox = {
        let checkbox = CheckBox()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.tintColor = ColorManager.shared.confirmingGreen
        return checkbox
    }()
    
    private lazy var addressNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 600])
        return label
    }()
    
    private lazy var goToAddressButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 500])
        button.setTitle("Details", for: .normal)
        button.setTitleColor(ColorManager.shared.label, for: .normal)
        button.setTitleColor(ColorManager.shared.label.withAlphaComponent(0.5), for: .highlighted)
        button.backgroundColor = ColorManager.shared.headerElementsColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(goToAddressButtonTapped), for: .touchUpInside)
        return button
    }()

    private func setupUI() {
        backgroundColor = ColorManager.shared.background
        
        addSubview(isPreferredAdressCheckBox)
        addSubview(addressNameLabel)
        addSubview(goToAddressButton)
        
        NSLayoutConstraint.activate([
            isPreferredAdressCheckBox.centerYAnchor.constraint(equalTo: centerYAnchor),
            isPreferredAdressCheckBox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            isPreferredAdressCheckBox.heightAnchor.constraint(equalToConstant: Constants.checkboxSize),
            isPreferredAdressCheckBox.widthAnchor.constraint(equalToConstant: Constants.checkboxSize),
            
            addressNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            addressNameLabel.leadingAnchor.constraint(equalTo: isPreferredAdressCheckBox.trailingAnchor, constant: 32),
            addressNameLabel.trailingAnchor.constraint(equalTo: goToAddressButton.leadingAnchor, constant: -32),
            
            goToAddressButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            goToAddressButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            goToAddressButton.heightAnchor.constraint(equalToConstant: 40),
            goToAddressButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    @objc
    private func goToAddressButtonTapped() {
        goToAddressHandler()
    }
    
}
