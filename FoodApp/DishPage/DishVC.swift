//
//  DishVC.swift
//  FoodApp
//

import UIKit

final class DishVC: UIViewController {
    
    private let dish: Dish
    private let relatedProducts: [UIImage]
    
    // MARK: - Header props.
    
    private let headerHeight = 52.0
    private let headerButtonSize = 44.0
    private let fontWeightAxis = 2003265652
    
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
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var dishTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 21, axis: [fontWeightAxis : 650])
        label.text = dish.name
        label.textColor = ColorManager.shared.label
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
        button.addTarget(self, action: #selector(favoritButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Photo carousele props.
    
    private lazy var carouselPhotos: [UIImage] = []
    private var dataSource: UICollectionViewDiffableDataSource<Int, UIImage>!
    
    private lazy var photoCarouseleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var coloredBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.type = .radial
        layer.colors = [
            UIColor(red: 0.149, green: 0.149, blue: 0.149, alpha: 0.20).cgColor,
            UIColor(red: 0.149, green: 0.149, blue: 0.149, alpha: 0.7).cgColor
        ]
        layer.startPoint = CGPoint(x: 0.5, y: 0.4)
        layer.endPoint = CGPoint(x: 0, y: 1)
        layer.isHidden = traitCollection.userInterfaceStyle != .dark
        return layer
    }()
    
    private lazy var carouselCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.id)
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var pageControl: PageControl = {
        let pageControl = PageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = carouselPhotos.count
        pageControl.currentPage = 1
        pageControl.dotRadius = 3
        pageControl.dotSpacings = 7
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.backgroundColor = .clear
        return pageControl
    }()
    
    // MARK: - Description section props.
    
    private lazy var descriptionSectionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dishName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 25, axis: [fontWeightAxis : 470])
        label.text = dish.name
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var ratingAndDeliveryStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var ratingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var ratingIcon: UIImageView = {
        let image = UIImage(named: "Star")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Raleway", size: 15)
        label.text = "4.8 ( 100+ Rewies )"
        return label
    }()
    
    private lazy var deliveryTimeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deliveriIcon: UIImageView = {
        let image = UIImage(named: "Clock")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var deliveryTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Raleway", size: 15)
        label.text = "Delivery in 30 min"
        return label
    }()
    
    private lazy var ingredientsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [fontWeightAxis : 600])
        label.text = "Ingredients"
        return label
    }()
    
    private lazy var ingredientsListLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Raleway", size: 14)
        label.textColor = ColorManager.shared.label.withAlphaComponent(0.7)
        label.numberOfLines = 0
        label.text = """
Ground beef, hamburger buns, salt, pepper. 
Optional: cheese, lattuce, tomato, onion, pickles, mayonnaise.
"""
        return label
    }()
    
    // MARK: - Related section props.
    
    private lazy var relatedProductSectionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var relatedProductLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [fontWeightAxis : 600])
        label.text = "Related Product"
        return label
    }()
    
    private lazy var relatedProductStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.backgroundColor = .red.withAlphaComponent(0.3)
        return stack
    }()
    
    // MARK: - Order bar
    
    private let orderBarHeight: CGFloat = 72
    private let orderBarMargin: CGFloat = 18
    private let orderBarPadding: CGFloat = 12
    private var orderBarElementSize: CGFloat { orderBarHeight - orderBarPadding * 2 }
    private var plusMinusButtonsSize: CGFloat { orderBarElementSize - (orderBarPadding * 2) }
    
    private lazy var orderBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = orderBarHeight / 2
        view.backgroundColor = ColorManager.shared.label.withAlphaComponent(0.5)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowRadius = 30
        
        view.isHidden = true
        return view
    }()
    
    private lazy var blurEffect: UIVisualEffectView = {
        let view = UIVisualEffectView()
        let blur = UIBlurEffect(style: .regular)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = orderBarHeight / 2
        view.clipsToBounds = true
        view.effect = blur
        return view
    }()
    
    private lazy var addItemBlockView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = orderBarElementSize / 2
        return view
    }()
    
    private lazy var minusItemButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = plusMinusButtonsSize / 2
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var plusItemButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = plusMinusButtonsSize / 2
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "01"
        return label
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("Add to Cart", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.black.withAlphaComponent(0.7), for: .highlighted)
        button.titleLabel?.font = UIFont.getVariableVersion(of: "Raleway", size: 17, axis: [fontWeightAxis : 650])
        button.layer.cornerRadius = orderBarElementSize / 2
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Controller methods
    
    init(dish: Dish, related: [UIImage], color: UIColor) {
        self.dish = dish
        self.relatedProducts = related
        super.init(nibName: nil, bundle: nil)
        coloredBackgroundView.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCarouselPhotos()
        setupUI()
        setupConstraints()
        setupRelatedProducts()
        configureDataSource()
        applySnapshot()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = coloredBackgroundView.bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if traitCollection.userInterfaceStyle == .dark {
                gradientLayer.isHidden = false
            } else {
                gradientLayer.isHidden = true
            }
        }
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.background
        view.addSubview(headerView)
        view.addSubview(photoCarouseleView)
        view.addSubview(descriptionSectionView)
        view.addSubview(relatedProductSectionView)
        view.addSubview(orderBarView)
        
        headerView.addSubview(backButton)
        headerView.addSubview(dishTitleLabel)
        headerView.addSubview(favoritButton)
        
        photoCarouseleView.addSubview(coloredBackgroundView)
        photoCarouseleView.addSubview(carouselCollectionView)
        photoCarouseleView.addSubview(pageControl)
        coloredBackgroundView.layer.addSublayer(gradientLayer)

        descriptionSectionView.addSubview(dishName)
        descriptionSectionView.addSubview(ratingAndDeliveryStack)
        descriptionSectionView.addSubview(ingredientsLabel)
        descriptionSectionView.addSubview(ingredientsListLabel)
        ratingView.addSubview(ratingIcon)
        ratingView.addSubview(ratingLabel)
        deliveryTimeView.addSubview(deliveriIcon)
        deliveryTimeView.addSubview(deliveryTimeLabel)
        ratingAndDeliveryStack.addArrangedSubview(ratingView)
        ratingAndDeliveryStack.addArrangedSubview(deliveryTimeView)
        
        relatedProductSectionView.addSubview(relatedProductLabel)
        relatedProductSectionView.addSubview(relatedProductStack)
        
        orderBarView.addSubview(blurEffect)
        orderBarView.addSubview(addItemBlockView)
        orderBarView.addSubview(addToCartButton)
        addItemBlockView.addSubview(minusItemButton)
        addItemBlockView.addSubview(plusItemButton)
        addItemBlockView.addSubview(amountLabel)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // Header view constraints
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
            
            // Photo carousel view constraints
            photoCarouseleView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            photoCarouseleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoCarouseleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoCarouseleView.heightAnchor.constraint(equalToConstant: 316),
            coloredBackgroundView.bottomAnchor.constraint(equalTo: photoCarouseleView.bottomAnchor, constant: -36),
            coloredBackgroundView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            coloredBackgroundView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            coloredBackgroundView.heightAnchor.constraint(equalToConstant: 184),
            carouselCollectionView.topAnchor.constraint(equalTo: photoCarouseleView.topAnchor),
            carouselCollectionView.leadingAnchor.constraint(equalTo: photoCarouseleView.leadingAnchor),
            carouselCollectionView.trailingAnchor.constraint(equalTo: photoCarouseleView.trailingAnchor),
            carouselCollectionView.bottomAnchor.constraint(equalTo: photoCarouseleView.bottomAnchor, constant: -36),
            pageControl.topAnchor.constraint(equalTo: carouselCollectionView.bottomAnchor, constant: 16),
            pageControl.centerXAnchor.constraint(equalTo: photoCarouseleView.centerXAnchor),
            
            // Description section view constraints
            descriptionSectionView.topAnchor.constraint(equalTo: photoCarouseleView.bottomAnchor),
            descriptionSectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionSectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dishName.topAnchor.constraint(equalTo: descriptionSectionView.topAnchor, constant: 20),
            dishName.leadingAnchor.constraint(equalTo: descriptionSectionView.leadingAnchor, constant: 16),
            dishName.trailingAnchor.constraint(equalTo: descriptionSectionView.trailingAnchor, constant: -16),
            ratingAndDeliveryStack.topAnchor.constraint(equalTo: dishName.bottomAnchor, constant: 16),
            ratingAndDeliveryStack.leadingAnchor.constraint(equalTo: descriptionSectionView.leadingAnchor, constant: 16),
            ratingAndDeliveryStack.trailingAnchor.constraint(equalTo: descriptionSectionView.trailingAnchor, constant: -16),
            ratingAndDeliveryStack.heightAnchor.constraint(equalToConstant: 44),
            ratingIcon.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            ratingIcon.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor),
            ratingIcon.heightAnchor.constraint(equalToConstant: 18),
            ratingIcon.widthAnchor.constraint(equalToConstant: 18),
            ratingLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: ratingIcon.trailingAnchor, constant: 8),
            ratingLabel.trailingAnchor.constraint(equalTo: ratingView.trailingAnchor, constant: -8),
            deliveryTimeLabel.centerYAnchor.constraint(equalTo: deliveryTimeView.centerYAnchor),
            deliveryTimeLabel.trailingAnchor.constraint(equalTo: deliveryTimeView.trailingAnchor),
            deliveriIcon.centerYAnchor.constraint(equalTo: deliveryTimeView.centerYAnchor),
            deliveriIcon.trailingAnchor.constraint(equalTo: deliveryTimeLabel.leadingAnchor, constant: -8),
            deliveriIcon.heightAnchor.constraint(equalToConstant: 18),
            deliveriIcon.widthAnchor.constraint(equalToConstant: 18),
            ingredientsLabel.topAnchor.constraint(equalTo: ratingAndDeliveryStack.bottomAnchor, constant: 6),
            ingredientsLabel.leadingAnchor.constraint(equalTo: descriptionSectionView.leadingAnchor, constant: 16),
            ingredientsLabel.trailingAnchor.constraint(equalTo: descriptionSectionView.trailingAnchor, constant: -16),
            ingredientsListLabel.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 8),
            ingredientsListLabel.leadingAnchor.constraint(equalTo: descriptionSectionView.leadingAnchor, constant: 16),
            ingredientsListLabel.trailingAnchor.constraint(equalTo: descriptionSectionView.trailingAnchor, constant: -16),
            ingredientsListLabel.bottomAnchor.constraint(equalTo: descriptionSectionView.bottomAnchor),
            
            // Related product section view constraints
            relatedProductSectionView.topAnchor.constraint(equalTo: descriptionSectionView.bottomAnchor, constant: 24),
            relatedProductSectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            relatedProductSectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            relatedProductLabel.topAnchor.constraint(equalTo: relatedProductSectionView.topAnchor, constant: 16),
            relatedProductLabel.leadingAnchor.constraint(equalTo: relatedProductSectionView.leadingAnchor, constant: 16),
            relatedProductLabel.trailingAnchor.constraint(equalTo: relatedProductSectionView.trailingAnchor, constant: -16),
            relatedProductStack.topAnchor.constraint(equalTo: relatedProductLabel.bottomAnchor, constant: 16),
            relatedProductStack.leadingAnchor.constraint(equalTo: relatedProductSectionView.leadingAnchor, constant: 16),
            relatedProductStack.trailingAnchor.constraint(equalTo: relatedProductSectionView.trailingAnchor, constant: -16),
            relatedProductStack.heightAnchor.constraint(equalToConstant: 130),
            
            // Order bar view constraints
            orderBarView.heightAnchor.constraint(equalToConstant: orderBarHeight),
            orderBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: orderBarMargin),
            orderBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -orderBarMargin),
            orderBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -orderBarMargin),
            blurEffect.topAnchor.constraint(equalTo: orderBarView.topAnchor),
            blurEffect.leadingAnchor.constraint(equalTo: orderBarView.leadingAnchor),
            blurEffect.trailingAnchor.constraint(equalTo: orderBarView.trailingAnchor),
            blurEffect.bottomAnchor.constraint(equalTo: orderBarView.bottomAnchor),
            addItemBlockView.topAnchor.constraint(equalTo: orderBarView.topAnchor, constant: orderBarPadding),
            addItemBlockView.leadingAnchor.constraint(equalTo: orderBarView.leadingAnchor, constant: orderBarPadding),
            addItemBlockView.bottomAnchor.constraint(equalTo: orderBarView.bottomAnchor, constant: -orderBarPadding),
            addItemBlockView.widthAnchor.constraint(equalToConstant: 120),
            addToCartButton.topAnchor.constraint(equalTo: orderBarView.topAnchor, constant: orderBarPadding),
            addToCartButton.leadingAnchor.constraint(equalTo: addItemBlockView.trailingAnchor, constant: orderBarPadding),
            addToCartButton.trailingAnchor.constraint(equalTo: orderBarView.trailingAnchor, constant: -orderBarPadding),
            addToCartButton.bottomAnchor.constraint(equalTo: orderBarView.bottomAnchor, constant: -orderBarPadding),
            minusItemButton.centerYAnchor.constraint(equalTo: addItemBlockView.centerYAnchor),
            minusItemButton.leadingAnchor.constraint(equalTo: addItemBlockView.leadingAnchor, constant: orderBarPadding + 6),
            minusItemButton.heightAnchor.constraint(equalToConstant: plusMinusButtonsSize),
            minusItemButton.widthAnchor.constraint(equalToConstant: plusMinusButtonsSize),
            plusItemButton.centerYAnchor.constraint(equalTo: addItemBlockView.centerYAnchor),
            plusItemButton.trailingAnchor.constraint(equalTo: addItemBlockView.trailingAnchor, constant: -(orderBarPadding + 6)),
            plusItemButton.heightAnchor.constraint(equalToConstant: plusMinusButtonsSize),
            plusItemButton.widthAnchor.constraint(equalToConstant: plusMinusButtonsSize),
            amountLabel.centerXAnchor.constraint(equalTo: addItemBlockView.centerXAnchor),
            amountLabel.centerYAnchor.constraint(equalTo: addItemBlockView.centerYAnchor)
        ])
    }
    
    private func setupRelatedProducts() {
        let productBackColors = ColorManager.shared.getColors(relatedProducts.count)
        for i in 0...relatedProducts.count-1 {
            let view = UIView()
            let imageView = UIImageView(image: relatedProducts[i])
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = productBackColors[i]
            view.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            relatedProductStack.addArrangedSubview(view)
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                imageView.heightAnchor.constraint(equalToConstant: 50),
                imageView.widthAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
    
    private func loadCarouselPhotos() {
        for _ in 0...3 {
            guard let data = dish.imageData, let image = UIImage(data: data) else { continue }
            carouselPhotos.append(image)
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, UIImage>(collectionView: carouselCollectionView) { (collectionView, indexPath, image) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.id, for: indexPath) as? CarouselCell else {
                fatalError("Cannot create new cell")
            }
            cell.configure(with: image)
            return cell
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, UIImage>()
        snapshot.appendSections([0])
        snapshot.appendItems(carouselPhotos, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - Objc methods
    
    @objc
    private func backButtonTapped() {
        dismiss(animated: true)
    }

    @objc
    private func favoritButtonTapped() {
        print(#function)
    }
    
    @objc
    private func minusButtonTapped() {
        var amount = Int(amountLabel.text ?? "0") ?? 0
        if amount > 0 {
            amount -= 1
            amountLabel.text = amount > 9 ? "\(amount)" : "0\(amount)"
        }
    }
    
    @objc 
    private func plusButtonTapped() {
        var amount = Int(amountLabel.text ?? "0") ?? 0
        amount += 1
        amountLabel.text = amount > 9 ? "\(amount)" : "0\(amount)"
    }
    
    @objc
    private func addToCartButtonTapped() {
        print(#function)
    }
    
}

// MARK: - CollectionView Delegate

extension DishVC: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.scrollViewDidScroll(scrollView)
    }
}

// MARK: - Collection FlowLayout Delegate

extension DishVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return carouselCollectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
