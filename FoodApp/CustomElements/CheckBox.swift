//
//  CheckBox.swift
//  FoodApp
//

import UIKit

class CheckBox: UIButton {
    
    let checkedImage = UIImage(systemName: "checkmark")! as UIImage
    
    var isChecked: Bool = false {
        didSet {
            self.setImage(isChecked ? checkedImage : nil, for: .normal)
        }
    }
        
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
        
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
