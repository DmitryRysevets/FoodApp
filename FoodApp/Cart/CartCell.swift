//
//  CartCell.swift
//  FoodApp
//

import UIKit

class CartCell: UITableViewCell {
    static let id = "CartCell"
    
    var dishData: Dish! {
        didSet {
            
        }
    }
    
    private lazy var imageColorBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var producImageView: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
