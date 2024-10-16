//
//  NoMessagesCell.swift
//  FoodApp
//

import UIKit

class NoMessagesCell: UITableViewCell {
    static let id = "NoMessagesCell"

    private lazy var noMessagesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Raleway", size: 14)
        label.text = "You don't have any messages yet"
        label.textColor = .white
        return label
    }()
    
    func setupCell() {
        backgroundColor = .clear
        addSubview(noMessagesLabel)
        
        NSLayoutConstraint.activate([
            noMessagesLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            noMessagesLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
