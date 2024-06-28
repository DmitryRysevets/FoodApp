//
//  UISearchBar + Extension.swift
//  FoodApp
//

import UIKit

extension UISearchBar {
    func updateHeight(height: CGFloat, radius: CGFloat = 8.0) {
        let image: UIImage? = UIImage.imageWithColor(color: UIColor.clear, size: CGSize(width: 1, height: height))
        setSearchFieldBackgroundImage(image, for: .normal)
        for subview in self.subviews {
            for subSubViews in subview.subviews {
                if #available(iOS 13.0, *) {
                    for child in subSubViews.subviews {
                        if let textField = child as? UISearchTextField {
                            textField.layer.cornerRadius = radius
                            textField.clipsToBounds = true
                        }
                    }
                    continue
                }
                if let textField = subSubViews as? UITextField {
                    textField.layer.cornerRadius = radius
                    textField.clipsToBounds = true
                }
            }
        }
    }
    
    func setPlaceholderFont(_ font: UIFont) {
        if let textField = self.value(forKey: "searchField") as? UITextField {
            let placeholder = textField.placeholder ?? ""
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.font: font]
            )
        }
    }
    
    func setSideImage(_ image: UIImage, imageSize: CGSize, padding: CGFloat = 0, tintColor: UIColor, side: sideOfSearchBar) {
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: imageSize.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageSize.height).isActive = true
        imageView.tintColor = tintColor
        
        if padding != 0 {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fill
            
            let paddingView = UIView()
            paddingView.translatesAutoresizingMaskIntoConstraints = false
            paddingView.widthAnchor.constraint(equalToConstant: padding).isActive = true
            paddingView.heightAnchor.constraint(equalToConstant: padding).isActive = true
            
            switch side {
            case .right:
                stackView.addArrangedSubview(imageView)
                stackView.addArrangedSubview(paddingView)
                searchTextField.rightView = stackView
            case .left:
                stackView.addArrangedSubview(paddingView)
                stackView.addArrangedSubview(imageView)
                searchTextField.leftView = stackView
            }
            
        } else {
            searchTextField.rightView = imageView
        }
    }
    
    enum sideOfSearchBar {
    case right, left
    }

}

