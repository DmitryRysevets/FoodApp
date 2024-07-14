//
//  TextField.swift
//  FoodApp
//

import UIKit

class TextField: UITextField {

    var paddingTop: CGFloat = 8
    var paddingLeft: CGFloat = 16
    var paddingBottom: CGFloat = 8
    var paddingRight: CGFloat = 16

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

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 22
        layer.masksToBounds = true
    }
}
