//
//  FavoriteCell.swift
//  FoodApp
//

import UIKit

final class FavoriteCell: UITableViewCell {
    
    static let id = "FavoriteCell"
    
    var favoriteDish: Dish! {
        didSet {
            setupUI()
            setupConstraints()
            
            productNameLabel.text = favoriteDish.name
            productWeightLabel.text = "\(favoriteDish.weight)g (1 pcs)"
            productPriceLabel.text = "$\(String(format: "%.2f", favoriteDish.price))"
            
            if favoriteDish.isOffer, let recentPrice = favoriteDish.recentPrice {
                let text = "$\(String(format: "%.2f", recentPrice))"
                let attributes: [NSAttributedString.Key: Any] = [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
                let attributedString = NSAttributedString(string: text, attributes: attributes)
                productRecentPriceLabel.attributedText = attributedString
                setPriceConstraintWithOffer()
            } else {
                setPriceConstraintWithouOffer()
            }
            
            if let image = favoriteDish.imageData {
                producImageView.image = UIImage(data: image)
            } else {
                producImageView.image = UIImage(named: "EmptyPlate")
            }
        }
    }
    
    var cartItemImageBackColor: UIColor = ColorManager.shared.green {
        didSet {
            imageColorBackground.backgroundColor = cartItemImageBackColor
        }
    }
    
    private lazy var productPriceLabelCenterYConstraint: NSLayoutConstraint = productPriceLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
    
    private lazy var imageColorBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = cartItemImageBackColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 22
        return view
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.type = .radial
        layer.colors = [
            UIColor(red: 0.149, green: 0.149, blue: 0.149, alpha: 0.20).cgColor,
            UIColor(red: 0.149, green: 0.149, blue: 0.149, alpha: 0.7).cgColor
        ]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        layer.isHidden = traitCollection.userInterfaceStyle != .dark
        return layer
    }()
    
    private lazy var producImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 18, axis: [Constants.fontWeightAxis : 600])
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.shadowOpacity = 0.2
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 2
        return label
    }()
    
    private lazy var productWeightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label.withAlphaComponent(0.5)
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var productRecentPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientLayer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productRecentPriceLabel.attributedText = nil
    }
    
    // MARK: - Private methods
    
    private func updateGradientLayer() {
        gradientLayer.frame = imageColorBackground.bounds
        if traitCollection.userInterfaceStyle == .dark {
            gradientLayer.isHidden = false
        } else {
            gradientLayer.isHidden = true
        }
    }
    
    private func setupUI() {
        backgroundColor = ColorManager.shared.background
        
        addSubview(imageColorBackground)
        addSubview(productRecentPriceLabel)
        addSubview(productPriceLabel)
        
        imageColorBackground.addSubview(producImageView)
        imageColorBackground.addSubview(productNameLabel)
        imageColorBackground.addSubview(productWeightLabel)
        
        imageColorBackground.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageColorBackground.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageColorBackground.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            imageColorBackground.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            imageColorBackground.heightAnchor.constraint(equalToConstant: 76),
            
            producImageView.leadingAnchor.constraint(equalTo: imageColorBackground.leadingAnchor, constant: 16),
            producImageView.centerYAnchor.constraint(equalTo: imageColorBackground.centerYAnchor),
            producImageView.heightAnchor.constraint(equalTo: imageColorBackground.heightAnchor, constant: -12),
            producImageView.widthAnchor.constraint(equalTo: producImageView.heightAnchor),
            
            productNameLabel.leadingAnchor.constraint(equalTo: producImageView.trailingAnchor, constant: 16),
            productNameLabel.trailingAnchor.constraint(equalTo: imageColorBackground.trailingAnchor, constant: -16),
            productNameLabel.centerYAnchor.constraint(equalTo: imageColorBackground.centerYAnchor, constant: -10),
            
            productWeightLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 4),
            productWeightLabel.leadingAnchor.constraint(equalTo: productNameLabel.leadingAnchor),
            
            productRecentPriceLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -9),
            productRecentPriceLabel.centerXAnchor.constraint(equalTo: productPriceLabel.centerXAnchor),
            
            productPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        productPriceLabelCenterYConstraint.isActive = true
    }
    
    private func setPriceConstraintWithOffer() {
        productPriceLabelCenterYConstraint.constant = 9
    }
    
    private func setPriceConstraintWithouOffer() {
        productPriceLabelCenterYConstraint.constant = 0
    }
}

