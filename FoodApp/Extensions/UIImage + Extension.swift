//
//  UIImage + Extension.swift
//  FoodApp
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}
