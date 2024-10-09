//
//  NotificationCell.swift
//  FoodApp
//

import UIKit

class NotificationCell: UITableViewCell {
    static let id = "NotificationCell"

    var message = "" {
        didSet {
            messageLabel.text = message
            setupUI()
        }
    }
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Raleway", size: 14)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private func setupUI() {
        backgroundColor = .clear
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
