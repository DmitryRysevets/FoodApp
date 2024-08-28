//
//  OrderHistoryTableCell.swift
//  FoodApp
//

import UIKit

final class OrderHistoryTableCell: UITableViewCell {

    static let id = "OrderHistoryTableCell"
    
    var stringOrderDate: String? {
        didSet {
            orderDateLabel.text = stringOrderDate
        }
    }
    
    var stringOrderAmount: String? {
        didSet {
            orderAmountLabel.text = stringOrderAmount
            setupUI()
        }
    }
    
    private lazy var orderDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var orderAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var chevronImageView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = ColorManager.shared.label
        return imageView
    }()

    private func setupUI() {
        backgroundColor = ColorManager.shared.background
        
        addSubview(orderDateLabel)
        addSubview(orderAmountLabel)
        addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            orderDateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            orderDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            orderDateLabel.trailingAnchor.constraint(equalTo: orderAmountLabel.leadingAnchor, constant: -16),
            
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            
            orderAmountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            orderAmountLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -16),
            orderAmountLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
}
