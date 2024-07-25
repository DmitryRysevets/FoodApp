//
//  ProfileMenuCell.swift
//  FoodApp
//

import UIKit

class ProfileMenuCell: UITableViewCell {

    static let id = "ProfileMenuCell"
    
    var menuItemName: String! {
        didSet {
            menuItemLabel.text = menuItemName
            setupUI()
        }
    }
    
    private lazy var menuItemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 600])
        return label
    }()

    private func setupUI() {
        backgroundColor = ColorManager.shared.background
        addSubview(menuItemLabel)
        NSLayoutConstraint.activate([
            menuItemLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            menuItemLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
}
