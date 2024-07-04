//
//  TabBarVC.swift
//  FoodApp
//

import UIKit

final class DishCell: UICollectionViewCell {
    static let id = "DishCell"
    
    lazy var dishData = Dish(id: "", name: "", description: "", tags: [], weight: 0, calories: 0, protein: 0, carbs: 0, fats: 0, isOffer: false, price: 0, recentPrice: 0, imageData: nil) {
        didSet {
            nameLabel.text = dishData.name
            actualPriseLabel.text = String(dishData.price)
            if let data = dishData.imageData {
                dishImage.image = UIImage(data: data)
            }
        }
    }
    
    lazy var customShapeView: DishCellShapeView = {
        let view = DishCellShapeView()
        view.frame = bounds
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = ColorManager.shared.background
        button.backgroundColor = ColorManager.shared.label
        button.addTarget(self, action: #selector(addButtonDidTaped), for: .touchUpInside)
        return button
    }()
    
    private lazy var dishImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "test")
        view.frame = CGRect(x: 20, y: 10, width: bounds.width - 40, height: bounds.width - 40)
        view.layer.cornerRadius = (bounds.width - 40) / 2
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Classic Delux Burger"
        label.font = UIFont(name: "Raleway", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private lazy var actualPriseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$4.00"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var regularPriseLabel: UILabel = {
        let label = UILabel()
        let text = "$5.00"
        let attributes: [NSAttributedString.Key: Any] = [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11)
        label.textColor = .darkGray
        label.textAlignment = .left
        return label
    }()
    
    private lazy var startingFromLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Starting From"
        label.font = .systemFont(ofSize: 9, weight: .light)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Favorite")
        let resizedImage = image?.resized(to: CGSize(width: 16, height: 15))
        button.setImage(resizedImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = 14
        button.tintColor = ColorManager.shared.label
        button.addTarget(self, action: #selector(favoriteButtonDidTaped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(customShapeView)
        addSubview(addButton)
        addSubview(nameLabel)
        addSubview(favoriteButton)
        addSubview(actualPriseLabel)
        addSubview(regularPriseLabel)
        addSubview(startingFromLabel)
        
        customShapeView.addSubview(dishImage)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            addButton.widthAnchor.constraint(equalToConstant: frame.width / 4.7),
            addButton.heightAnchor.constraint(equalToConstant: frame.width / 4.7),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48),
            nameLabel.heightAnchor.constraint(equalToConstant: 24),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            favoriteButton.heightAnchor.constraint(equalToConstant: 28),
            favoriteButton.widthAnchor.constraint(equalToConstant: 28),
            actualPriseLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            actualPriseLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            actualPriseLabel.heightAnchor.constraint(equalToConstant: 20),
            regularPriseLabel.leadingAnchor.constraint(equalTo: actualPriseLabel.trailingAnchor, constant: 6),
            regularPriseLabel.bottomAnchor.constraint(equalTo: actualPriseLabel.bottomAnchor),
            regularPriseLabel.heightAnchor.constraint(equalTo: actualPriseLabel.heightAnchor),
            startingFromLabel.bottomAnchor.constraint(equalTo: actualPriseLabel.topAnchor),
            startingFromLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            startingFromLabel.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    @objc
    private func addButtonDidTaped() {
        print(#function)
    }
    
    @objc
    private func favoriteButtonDidTaped() {
        print(#function)
    }
    
}
