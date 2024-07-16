//
//  FavoriteCell.swift
//  FoodApp
//

import UIKit

final class FavoriteCell: UITableViewCell {
    
    static let id = "FavoriteCell"
    
    var favoriteDish: Dish! {
        didSet {
            
        }
    }
    
    var cartItemImageBackColor: UIColor = ColorManager.shared.green {
        didSet {
            imageColorBackground.backgroundColor = cartItemImageBackColor
        }
    }
    
    private lazy var imageColorBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = cartItemImageBackColor
        view.layer.cornerRadius = 24
        return view
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
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 16, axis: [Constants.fontWeightAxis : 650])
        return label
    }()
    
    private lazy var productWeightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.labelGray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var productIngredientsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    // MARK: - Private methods
    
    private func setupUI() {
        
    }
    
    private func setupConstraintsForOddCell() {
        
    }
    
    private func setupConstraintsForEvenCell() {
        
    }
    
    private func setupGeneralConstraints() {
        
    }
    
}

