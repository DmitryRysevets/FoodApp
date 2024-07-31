//
//  TextField.swift
//  FoodApp
//

import UIKit

final class TextField: UITextField, Warningable {

    var paddingTop: CGFloat = 8
    var paddingLeft: CGFloat = 16
    var paddingBottom: CGFloat = 8
    var paddingRight: CGFloat = 16
    
    private let normalBorderColor = ColorManager.shared.regularFieldBorderColor
    private let warningBorderColor = ColorManager.shared.warningRed.cgColor
    
    var isInWarning: Bool = false {
        didSet {
            updateBorder()
        }
    }
    
    private func updateBorder() {
        layer.borderColor = isInWarning ? warningBorderColor : normalBorderColor
        layer.borderWidth = isInWarning ? 1 : 0.5
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let insetBounds = bounds.inset(by: UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight))
        return insetBounds
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let insetBounds = bounds.inset(by: UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight))
        return insetBounds
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let insetBounds = bounds.inset(by: UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight))
        return insetBounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        layer.cornerRadius = 22
        layer.borderWidth = 0.5
        layer.borderColor = normalBorderColor
        backgroundColor = ColorManager.shared.regularFieldColor
        tintColor = ColorManager.shared.orange
        textColor = ColorManager.shared.label
        font = UIFont.systemFont(ofSize: 17)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
