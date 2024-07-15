//
//  RadioButton.swift
//  FoodApp
//

import UIKit

class RadioButton: UIButton {
    var alternateButton:Array<RadioButton>?
    
    private let configurationForSelectedImage = UIImage.SymbolConfiguration(pointSize: 17, weight: .heavy)
    private lazy var selectedImage = UIImage(systemName: "circle", withConfiguration: configurationForSelectedImage)
    
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
                self.layer.borderWidth = 0
                self.backgroundColor = ColorManager.shared.payment_selectedRadioButtonBackColor
                self.setImage(selectedImage, for: .selected)
            } else {
                self.layer.borderWidth = 1.5
                self.backgroundColor = .white
                self.setImage(.none, for: .selected)
            }
        }
    }
}
