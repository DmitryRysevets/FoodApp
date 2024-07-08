//
//  CartCell.swift
//  FoodApp
//

import UIKit

class CartCell: UITableViewCell {
    
    static let id = "CartCell"
    
    var viewModel: CartCellViewModelProtocol! {
        didSet {
            setupUI()
            setupConstraints()
            
            productNameLabel.text = viewModel.productName
            productWeightLabel.text = viewModel.productWeight
            productPriceLabel.text = viewModel.productPrice
            amountLabel.text = viewModel.amountOfProduct
            
            if let image = viewModel.producImageData {
                producImageView.image = UIImage(data: image)
            } else {
                producImageView.image = UIImage(named: "EmptyPlate")
            }
        }
    }
    
    private lazy var imageColorBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorManager.shared.green
        return view
    }()
    
    private lazy var producImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var productWeightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var amountOfProductView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var minusItemButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
//        button.layer.cornerRadius = plusMinusButtonsSize / 2
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var plusItemButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
//        button.layer.cornerRadius = plusMinusButtonsSize / 2
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "1"
        return label
    }()
    
    private func setupUI() {
        
    }
    
    private func setupConstraints() {
        
    }
    
    @objc
    private func minusButtonTapped() {
        var amount = Int(amountLabel.text ?? "1") ?? 1
        if amount > 1 {
            amount -= 1
            amountLabel.text = "\(amount)"
        }
    }
    
    @objc
    private func plusButtonTapped() {
        var amount = Int(amountLabel.text ?? "1") ?? 1
        amount += 1
        amountLabel.text = "\(amount)"
    }
}
