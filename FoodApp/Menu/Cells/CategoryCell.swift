//
//  CategoryCell.swift
//  FoodApp
//

import UIKit

final class CategoryCell: UICollectionViewCell {
    static let id = "CategoryCell"
    
    var categorySwitchHandler: (() -> Void)?
    
    lazy var category: UIButton = {
        let button = UIButton()
        button.setTitle("Category", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(ColorManager.shared.background, for: .selected)
        button.titleLabel?.font = UIFont(name: "Raleway", size: 14)
        button.layer.borderWidth = 0.6
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.cornerRadius = bounds.height / 2
        button.addTarget(self, action: #selector(categoryToggle), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(category)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func categoryToggle(sender: UIButton) {
        if !sender.isSelected {
            setSelected()
            categorySwitchHandler?()
        }
    }
    
    func setSelected() {
        category.layer.borderWidth = 0
        category.backgroundColor = ColorManager.shared.label
        category.isSelected = true
    }
    
    func setUnselected() {
        category.layer.borderWidth = 0.6
        category.backgroundColor = ColorManager.shared.background
        category.isSelected = false
    }
}

