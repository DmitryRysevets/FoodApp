//
//  ColorManager.swift
//  FoodApp
//

import UIKit

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
    
    let gold = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.848, green: 0.678, blue: 0.405, alpha: 1)
        } else {
            return UIColor(red: 0.898, green: 0.878, blue: 0.705, alpha: 1)
        }
    }

    let green = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.476, green: 0.894, blue: 0.409, alpha: 1)
        } else {
            return UIColor(red: 0.776, green: 0.894, blue: 0.709, alpha: 1)
        }
    }

    let indigo = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.451, green: 0.510, blue: 0.794, alpha: 1)
        } else {
            return UIColor(red: 0.701, green: 0.760, blue: 0.894, alpha: 1)
        }
    }

    let mint = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.305, green: 0.901, blue: 0.560, alpha: 1)
        } else {
            return UIColor(red: 0.705, green: 0.901, blue: 0.760, alpha: 1)
        }
    }

    let teal = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.459, green: 0.801, blue: 0.801, alpha: 1)
        } else {
            return UIColor(red: 0.709, green: 0.901, blue: 0.901, alpha: 1)
        }
    }

    let sandy = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.902, green: 0.677, blue: 0.517, alpha: 1)
        } else {
            return UIColor(red: 0.952, green: 0.827, blue: 0.717, alpha: 1)
        }
    }

    let lavender = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.855, green: 0.697, blue: 0.712, alpha: 1)
        } else {
            return UIColor(red: 0.905, green: 0.847, blue: 0.862, alpha: 1)
        }
    }
    
    let orange = UIColor(red: 0.992, green: 0.592, blue: 0.196, alpha: 1)
    
    private let offerBorderPrimaryColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.149, green: 0.149, blue: 0.149, alpha: 1)
        } else {
            return UIColor.lightGray.withAlphaComponent(0.5)
        }
    }
    
    private let offerBackgroundPrimaryColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.149, green: 0.149, blue: 0.149, alpha: 1)
        } else {
            return UIColor.white
        }
    }
    
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
    
    func getOfferLabelColor(bounds: CGRect) -> UIColor? {
        let colors = [label.withAlphaComponent(0.3).cgColor, UIColor.clear.cgColor]
        return getGradientColor(bounds: bounds, colors: colors, parameter: .vertical)
    }

    func getOfferBorderColor(bounds: CGRect) -> CGColor? {
        let colors = [offerBorderPrimaryColor.cgColor, UIColor.clear.cgColor]
        return getGradientColor(bounds: bounds, colors: colors, parameter: .forOfferBorder)?.cgColor
    }
    
    func getOfferBackgroundColor(for theme: UIUserInterfaceStyle, bounds: CGRect) -> UIColor? {
        let colors = [offerBackgroundPrimaryColor.cgColor, green.cgColor]
        if theme == .dark {
            return getGradientColor(bounds: bounds, colors: colors, parameter: .forOfferBackDark)
        }
        return getGradientColor(bounds: bounds, colors: colors, parameter: .forOfferBackLight)
    }
    
    private func getGradientColor(bounds: CGRect, colors: [CGColor], parameter: GradientParameters) -> UIColor? {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors
        
        switch parameter {
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        case .vertical:
            gradient.startPoint = CGPoint(x: 0.5, y: 0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1)
        case .forOfferBackLight:
            gradient.startPoint = CGPoint(x: 0.1, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: cos(0.1))
        case .forOfferBackDark:
            gradient.startPoint = CGPoint(x: 0.2, y: 0.7)
            gradient.endPoint = CGPoint(x: 1, y: 1)
        case .forOfferBorder:
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.7, y: sin(20.0 * .pi / 130.0))
        }
        
        UIGraphicsBeginImageContext(gradient.bounds.size)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image!)
    }
    
    enum GradientParameters {
        case horizontal
        case vertical
        case forOfferBackLight
        case forOfferBackDark
        case forOfferBorder
    }
    
}
