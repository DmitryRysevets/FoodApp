//
//  MessageCell.swift
//  FoodApp
//

import UIKit

class MessageCell: UITableViewCell {
    static let id = "MessageCell"

    var message: MessageEntity! {
        didSet {
            titleLabel.text = message.title
            messageLabel.text = message.body
            
            if let date = message.date {
                timeLabel.text = dateFormatter.string(from: date)
            }
            
            setupUI()
        }
    }
    
    let dateFormatter: DateFormatter = {
        let formater = DateFormatter()
        formater.dateFormat = "E HH:mm"
        formater.locale = Locale(identifier: "en_US")
        return formater
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 15, axis: [Constants.fontWeightAxis : 650])
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Raleway", size: 14)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    private func setupUI() {
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(timeLabel)
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -16),
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
