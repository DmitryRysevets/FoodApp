//
//  PaymentMethodsCell.swift
//  FoodApp
//

import UIKit

class PaymentMethodsCell: UITableViewCell {

    static let id = "PaymentMethodsCell"
    
    var cardName: String! {
        didSet {
            cardNameLabel.text = cardName
            setupUI()
        }
    }
    
    var goToCardInfoHandler: (() -> Void)!
    
    private lazy var cardNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 600])
        return label
    }()
    
    private lazy var goToCardInfoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 500])
        button.setTitle("Info", for: .normal)
        button.setTitleColor(ColorManager.shared.label, for: .normal)
        button.setTitleColor(ColorManager.shared.label.withAlphaComponent(0.5), for: .highlighted)
        button.backgroundColor = ColorManager.shared.headerElementsColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(goToCardInfoButtonTapped), for: .touchUpInside)
        return button
    }()

    private func setupUI() {
        backgroundColor = ColorManager.shared.background
        
        addSubview(cardNameLabel)
        addSubview(goToCardInfoButton)
        
        NSLayoutConstraint.activate([
            cardNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            
            goToCardInfoButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            goToCardInfoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            goToCardInfoButton.heightAnchor.constraint(equalToConstant: 40),
            goToCardInfoButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    @objc
    private func goToCardInfoButtonTapped() {
        goToCardInfoHandler()
    }
    
}
