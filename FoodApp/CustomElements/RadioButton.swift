//
//  RadioButton.swift
//  FoodApp
//

import UIKit

class RadioButton: UIButton {
    
    var alternateButton:Array<RadioButton>?
    
    private let configurationForSelectedImage = UIImage.SymbolConfiguration(pointSize: 17, weight: .heavy)
    private lazy var selectedImage = UIImage(systemName: "circle", withConfiguration: configurationForSelectedImage)
    
    weak var associatedLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1.5
        layer.borderColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.3).cgColor
        layer.masksToBounds = true
        tintColor = ColorManager.shared.background
        setImage(selectedImage, for: .selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func unselectAlternateButtons() {
        if alternateButton != nil {
            self.isSelected = true
            
            for aButton:RadioButton in alternateButton! {
                aButton.isSelected = false
            }
        } else {
            toggleButton()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        unselectAlternateButtons()
        super.touchesBegan(touches, with: event)
    }
    
    func toggleButton() {
        self.isSelected = !isSelected
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderWidth = 0
                backgroundColor = ColorManager.shared.payment_selectedRadioButtonBackColor
                setImage(selectedImage, for: .selected)
                associatedLabel?.textColor = ColorManager.shared.label
            } else {
                layer.borderWidth = 1.5
                backgroundColor = .white
                setImage(.none, for: .selected)
                associatedLabel?.textColor = ColorManager.shared.labelGray
            }
        }
    }
}
