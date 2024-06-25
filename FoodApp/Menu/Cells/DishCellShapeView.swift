//
//  DishCellShapeView.swift
//  FoodApp
//

import UIKit

class DishCellShapeView: UIView {
    
    var fillColor: UIColor = ColorManager.shared.indigo.withAlphaComponent(0.5) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath()
        
        let scaleX = rect.width / 302.16
        let scaleY = rect.height / 382.09
        
        path.move(to: CGPoint(x: 32.95 * scaleX, y: 0))
        path.addLine(to: CGPoint(x: 269.21 * scaleX, y: 0))
        path.addCurve(to: CGPoint(x: 302.16 * scaleX, y: 32.95 * scaleY), controlPoint1: CGPoint(x: 287.41 * scaleX, y: 0), controlPoint2: CGPoint(x: 302.16 * scaleX, y: 14.75 * scaleY))
        path.addLine(to: CGPoint(x: 301.76 * scaleX, y: 274.27 * scaleY))
        path.addCurve(to: CGPoint(x: 272.83 * scaleX, y: 305.8 * scaleY), controlPoint1: CGPoint(x: 301.76 * scaleX, y: 295.46 * scaleY), controlPoint2: CGPoint(x: 289.2 * scaleX, y: 305.36 * scaleY))
        path.addLine(to: CGPoint(x: 251.3 * scaleX, y: 305.8 * scaleY))
        path.addCurve(to: CGPoint(x: 224.81 * scaleX, y: 332.29 * scaleY), controlPoint1: CGPoint(x: 236.67 * scaleX, y: 305.8 * scaleY), controlPoint2: CGPoint(x: 224.81 * scaleX, y: 317.66 * scaleY))
        path.addLine(to: CGPoint(x: 224.81 * scaleX, y: 350.06 * scaleY))
        path.addCurve(to: CGPoint(x: 191.1 * scaleX, y: 382.09 * scaleY), controlPoint1: CGPoint(x: 225.02 * scaleX, y: 369.45 * scaleY), controlPoint2: CGPoint(x: 212.88 * scaleX, y: 382.21 * scaleY))
        path.addLine(to: CGPoint(x: 32.95 * scaleX, y: 382.09 * scaleY))
        path.addCurve(to: CGPoint(x: 0, y: 349.14 * scaleY), controlPoint1: CGPoint(x: 14.75 * scaleX, y: 382.09 * scaleY), controlPoint2: CGPoint(x: 0, y: 367.33 * scaleY))
        path.addLine(to: CGPoint(x: 0, y: 32.95 * scaleY))
        path.addCurve(to: CGPoint(x: 32.95 * scaleX, y: 0), controlPoint1: CGPoint(x: 0, y: 14.75 * scaleY), controlPoint2: CGPoint(x: 14.75 * scaleX, y: 0))
        path.close()
        
        path.lineWidth = 1
        path.miterLimit = 4
        
        fillColor.setFill()
        path.fill()
    }
}

