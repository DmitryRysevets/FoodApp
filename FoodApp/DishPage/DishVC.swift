//
//  DishVC.swift
//  FoodApp
//

import UIKit

final class DishVC: UIViewController {
    
    let dish: Dish
    
    // MARK: - Header props.
    
    private let headerHeight = 52.0
    private let headerButtonSize = 44.0
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: configuration)?.resized(to: CGSize(width: 12, height: 16)).withTintColor(ColorManager.shared.label)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.tintColor = ColorManager.shared.label
        button.backgroundColor = ColorManager.shared.secondaryGrey
        button.layer.cornerRadius = headerButtonSize / 2
        button.addTarget(self, action: #selector(backButtonTaped), for: .touchUpInside)
        return button
    }()
    
    private lazy var dishTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Raleway", size: 18)
        label.textColor = ColorManager.shared.label
        label.text = dish.name
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var favoritButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Favorite")?.resized(to: CGSize(width: 22, height: 20)).withTintColor(ColorManager.shared.label)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.backgroundColor = ColorManager.shared.secondaryGrey
        button.layer.cornerRadius = headerButtonSize / 2
        button.addTarget(self, action: #selector(favoritButtonTaped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Photo carousele props.
    
    private lazy var photoCarouseleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var coloredBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        return view
    }()
    
    private lazy var dishImageView: UIImageView = {
        var image: UIImage = UIImage(named: "EmptyPlate")!
        if let data = dish.imageData {
            image = UIImage(data: data)!
        }
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Description view props.
    
    private lazy var descriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dishName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Raleway", size: 26)
        label.textColor = ColorManager.shared.label
        label.text = dish.name
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Controller methods
    
    init(dish: Dish, color: UIColor) {
        self.dish = dish
        super.init(nibName: nil, bundle: nil)
        coloredBackgroundView.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.background
        view.addSubview(headerView)
        view.addSubview(photoCarouseleView)
        view.addSubview(descriptionView)
        headerView.addSubview(backButton)
        headerView.addSubview(dishTitleLabel)
        headerView.addSubview(favoritButton)
        photoCarouseleView.addSubview(coloredBackgroundView)
        photoCarouseleView.addSubview(dishImageView)
        descriptionView.addSubview(dishName)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: headerHeight),
            backButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            favoritButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            favoritButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            favoritButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
            favoritButton.widthAnchor.constraint(equalTo: favoritButton.heightAnchor),
            dishTitleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: -4),
            dishTitleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            dishTitleLabel.trailingAnchor.constraint(equalTo: favoritButton.leadingAnchor, constant: -8),
            dishTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            
            photoCarouseleView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            photoCarouseleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoCarouseleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoCarouseleView.heightAnchor.constraint(equalToConstant: 316),
            coloredBackgroundView.bottomAnchor.constraint(equalTo: photoCarouseleView.bottomAnchor, constant: -36),
            coloredBackgroundView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            coloredBackgroundView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            coloredBackgroundView.heightAnchor.constraint(equalToConstant: 184),
            dishImageView.centerXAnchor.constraint(equalTo: photoCarouseleView.centerXAnchor),
            dishImageView.bottomAnchor.constraint(equalTo: photoCarouseleView.bottomAnchor, constant: -50),
            dishImageView.heightAnchor.constraint(equalToConstant: 250),
            dishImageView.widthAnchor.constraint(equalToConstant: 250),
            
            descriptionView.topAnchor.constraint(equalTo: photoCarouseleView.bottomAnchor),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            descriptionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dishName.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: 20),
            dishName.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 16)
        ])
    }
    
    // MARK: - Objc methods
    
    @objc
    private func backButtonTaped() {
        dismiss(animated: true)
    }

    @objc
    private func favoritButtonTaped() {
        
    }
    
}

