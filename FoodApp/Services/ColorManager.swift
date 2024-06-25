//
//  ColorManager.swift
//  FoodApp
//

import UIKit

//struct ColorManager {
//    
//    static let background = UIColor { (traitCollection: UITraitCollection) -> UIColor in
//        if traitCollection.userInterfaceStyle == .dark {
//            return UIColor(red: 0.063, green: 0.063, blue: 0.063, alpha: 1)
//        } else {
//            return UIColor.white
//        }
//    }
//    
//    static let label = UIColor { (traitCollection: UITraitCollection) -> UIColor in
//        if traitCollection.userInterfaceStyle == .dark {
//            return UIColor.white
//        } else {
//            return UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
//        }
//    }
//    
//    static let secondaryGrey = UIColor { (traitCollection: UITraitCollection) -> UIColor in
//        if traitCollection.userInterfaceStyle == .dark {
//            return UIColor(red: 0.105, green: 0.105, blue: 0.105, alpha: 1)
//        } else {
//            return UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
//        }
//    }
//    
//    static let orderButton = UIColor(red: 0.992, green: 0.592, blue: 0.196, alpha: 1)
//    
//    static let gold     = UIColor(red: 0.898, green: 0.878, blue: 0.705, alpha: 1)
//    static let green    = UIColor(red: 0.776, green: 0.894, blue: 0.709, alpha: 1)
//    static let indigo   = UIColor(red: 0.701, green: 0.760, blue: 0.894, alpha: 1)
//    static let mint     = UIColor(red: 0.705, green: 0.901, blue: 0.760, alpha: 1)
//    static let teal     = UIColor(red: 0.709, green: 0.901, blue: 0.901, alpha: 1)
//    static let sandy    = UIColor(red: 0.952, green: 0.827, blue: 0.717, alpha: 1)
//    static let lavender = UIColor(red: 0.905, green: 0.847, blue: 0.862, alpha: 1)
//    
//    static let offerBackgroundGradientColors = [ColorManager.background.cgColor, ColorManager.mint.cgColor]
//    static let offerLabelGradientColors      = [ColorManager.label.withAlphaComponent(0.3).cgColor, UIColor.clear.cgColor]
//    static let offerBorderGradientColors     = [UIColor.lightGray.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor]
//    
//    // Returns a sequence of colors where each new color does not repeat the previous three
//    static func getColors(_ quantity: Int) -> [UIColor] {
//        var colors: [UIColor] = []
//        var previousColors: [UIColor] = []
//        let tileColors: [UIColor] = [gold, green, indigo, mint, teal, sandy, lavender]
//        
//        for _ in 0..<quantity {
//            var newColor: UIColor
//            repeat {
//                newColor = tileColors.randomElement()!
//            } while previousColors.contains(newColor)
//            
//            colors.append(newColor)
//            previousColors.append(newColor)
//            if previousColors.count > 3 {
//                previousColors.removeFirst()
//            }
//        }
//        
//        return colors
//    }
//    
//    static func getGradientColor(bounds: CGRect, colors: [CGColor], direction: GradientDirection) -> UIColor? {
//        let gradient = CAGradientLayer()
//        gradient.frame = bounds
//        gradient.colors = colors
//        
//        switch direction {
//        case .horizontal:
//            gradient.startPoint = CGPoint(x: 0, y: 0.5)
//            gradient.endPoint = CGPoint(x: 1, y: 0.5)
//        case .vertical:
//            gradient.startPoint = CGPoint(x: 0.5, y: 0)
//            gradient.endPoint = CGPoint(x: 0.5, y: 1)
//        case .semiDiagonal:
//            gradient.startPoint = CGPoint(x: 0, y: 0.5)
//            gradient.endPoint = CGPoint(x: 0.7, y: sin(20.0 * .pi / 130.0))
//        case .diagonal:
//            gradient.startPoint = CGPoint(x: 0.1, y: 0.5)
//            gradient.endPoint = CGPoint(x: 1, y: cos(0.1))
//        }
//        
//        UIGraphicsBeginImageContext(gradient.bounds.size)
//        gradient.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return UIColor(patternImage: image!)
//    }
//    
//    enum GradientDirection {
//        case horizontal
//        case vertical
//        case semiDiagonal
//        case diagonal
//    }
//    
//}


class ColorManager {
    
    static let shared = ColorManager()
    
    private init() {}
    
    let background = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.063, green: 0.063, blue: 0.063, alpha: 1)
        } else {
            return UIColor.white
        }
    }
    
    let label = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor.white
        } else {
            return UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
        }
    }
    
    let secondaryGrey = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.105, green: 0.105, blue: 0.105, alpha: 1)
        } else {
            return UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        }
    }
    
    let orderButton = UIColor(red: 0.992, green: 0.592, blue: 0.196, alpha: 1)
    
    let gold     = UIColor(red: 0.898, green: 0.878, blue: 0.705, alpha: 1)
    let green    = UIColor(red: 0.776, green: 0.894, blue: 0.709, alpha: 1)
    let indigo   = UIColor(red: 0.701, green: 0.760, blue: 0.894, alpha: 1)
    let mint     = UIColor(red: 0.705, green: 0.901, blue: 0.760, alpha: 1)
    let teal     = UIColor(red: 0.709, green: 0.901, blue: 0.901, alpha: 1)
    let sandy    = UIColor(red: 0.952, green: 0.827, blue: 0.717, alpha: 1)
    let lavender = UIColor(red: 0.905, green: 0.847, blue: 0.862, alpha: 1)
    
    lazy var offerBackgroundGradientColors = [background.cgColor, mint.cgColor]
    lazy var offerLabelGradientColors      = [label.withAlphaComponent(0.3).cgColor, UIColor.clear.cgColor]
    lazy var offerBorderGradientColors     = [UIColor.lightGray.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor]
    
    // Returns a sequence of colors where each new color does not repeat the previous three
    func getColors(_ quantity: Int) -> [UIColor] {
        var colors: [UIColor] = []
        var previousColors: [UIColor] = []
        let tileColors: [UIColor] = [gold, green, indigo, mint, teal, sandy, lavender]
        
        for _ in 0..<quantity {
            var newColor: UIColor
            repeat {
                newColor = tileColors.randomElement()!
            } while previousColors.contains(newColor)
            
            colors.append(newColor)
            previousColors.append(newColor)
            if previousColors.count > 3 {
                previousColors.removeFirst()
            }
        }
        
        return colors
    }
    
    func getGradientColor(bounds: CGRect, colors: [CGColor], direction: GradientDirection) -> UIColor? {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors
        
        switch direction {
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        case .vertical:
            gradient.startPoint = CGPoint(x: 0.5, y: 0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1)
        case .semiDiagonal:
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.7, y: sin(20.0 * .pi / 130.0))
        case .diagonal:
            gradient.startPoint = CGPoint(x: 0.1, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: cos(0.1))
        }
        
        UIGraphicsBeginImageContext(gradient.bounds.size)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image!)
    }
    
    enum GradientDirection {
        case horizontal
        case vertical
        case semiDiagonal
        case diagonal
    }
    
}
