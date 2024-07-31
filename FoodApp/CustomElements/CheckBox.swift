//
//  CheckBox.swift
//  FoodApp
//

import UIKit

final class CheckBox: UIButton, Warningable {
    
    private let checkedImage = UIImage(systemName: "checkmark")! as UIImage
    private let normalBorderColor = ColorManager.shared.labelGray.cgColor
    private let warningBorderColor = ColorManager.shared.warningRed.cgColor
    
    var isChecked: Bool = false {
        didSet {
            self.setImage(isChecked ? checkedImage : nil, for: .normal)
        }
    }
    
    var isInWarning: Bool = false {
        didSet {
            self.layer.borderColor = isInWarning ? warningBorderColor : normalBorderColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = normalBorderColor
        backgroundColor = ColorManager.shared.background
        tintColor = ColorManager.shared.orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
