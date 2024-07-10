//
//  TabBarVC.swift
//  FoodApp
//

import UIKit

final class MenuTabVC: UIViewController {
    
    private var menu = Menu() {
        didSet {
            offerColors = ColorManager.shared.getColors(menu.offersContainer.offers.count)
            dishColors = ColorManager.shared.getColors(menu.dishes.count)
            isMenuDownloaded = true
            preloaderView.isHidden = true
            
            var offersSnapshot = NSDiffableDataSourceSnapshot<Int, Offer>()
            offersSnapshot.appendSections([0])
            offersSnapshot.appendItems(menu.offersContainer.offers, toSection: 0)
            self.nestedOffersSnapshot = offersSnapshot
            
            var categoriesSnapshot = NSDiffableDataSourceSnapshot<Int, String>()
            categoriesSnapshot.appendSections([0])
            categoriesSnapshot.appendItems(menu.categoriesContainer.categories, toSection: 0)
            self.nestedCategoriesSnapshot = categoriesSnapshot
            
            applySnapshot()
            
            var dataToSend: [CartItem] = []
            let quantity = 4
            let colors: [UIColor] = ColorManager.shared.getColors(quantity)
            for i in 0...quantity-1 {
                let item = CartItem(id: i, dish: menu.dishes[i], quantity: Int.random(in: 1...3), productImageBackColor: colors[i])
                dataToSend.append(item)
            }
            NotificationCenter.default.post(name: NSNotification.Name("DataNotification"), object: nil, userInfo: ["data": dataToSend])
            
        }
    }
    
    private var offerColors: [UIColor] = []
    private var dishColors: [UIColor] = []
    
    private var isMenuDownloaded = false
    private var isTabBarVisible = true
    
    private lazy var preloaderView = PreloaderView(frame: CGRect(x: 32, y: Int(view.center.y - 100), width: Int(view.frame.width - 64), height: 180))
    
    // MARK: - header vars.
    
    private let headerHeight = 52.0
    private let headerButtonSize = 44.0
    private var headerButtonCornerRadius: Double { headerButtonSize / 2 }
    private var headerBottomPadding: Double { headerHeight - headerButtonSize }
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorManager.shared.background
        return view
    }()
    
    private lazy var profilePhotoView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "Profile2")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = image
        view.contentMode = .center
        view.tintColor = ColorManager.shared.label
        view.backgroundColor = ColorManager.shared.headerElementsColor
        view.layer.cornerRadius = headerButtonCornerRadius
        return view
    }()
    
    private lazy var pinImageView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "Pin")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = image
        view.tintColor = ColorManager.shared.label
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var deliveryAdressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dhaka, Bangladesh"
        label.font = UIFont(name: "Raleway", size: 14)
        label.textColor = ColorManager.shared.label
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var notificationButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "GotNotification")?.resized(to: CGSize(width: 20, height: 20))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.backgroundColor = ColorManager.shared.headerElementsColor
        button.layer.cornerRadius = headerButtonCornerRadius
        button.addTarget(self, action: #selector(notificationButtonTaped), for: .touchUpInside)
        return button
    }()
    
    private lazy var layoutButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Layout")?.resized(to: CGSize(width: 20, height: 20))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image?.withTintColor(ColorManager.shared.label), for: .normal)
        button.backgroundColor = ColorManager.shared.headerElementsColor
        button.layer.cornerRadius = headerButtonCornerRadius
        button.addTarget(self, action: #selector(layoutButtonTaped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - search bar vars.
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.backgroundColor = ColorManager.shared.headerElementsColor
        searchBar.searchTextField.borderStyle = .none
        searchBar.updateHeight(height: 44, radius: 22)
        searchBar.tintColor = ColorManager.shared.orange
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.showsBookmarkButton = true
        searchBar.delegate = self
        return searchBar
    }()
    
    private var filteredDishes: [Dish] = []
    private var filteredByTagDishes: [Dish] = []
    private var isFilteredByTag = false
    private var isSearching = false
    
    // MARK: - collection view vars.
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(OffersContainerCell.self, forCellWithReuseIdentifier: OffersContainerCell.id)
        collection.register(CategoriesContainerCell.self, forCellWithReuseIdentifier: CategoriesContainerCell.id)
        collection.register(DishCell.self, forCellWithReuseIdentifier: DishCell.id)
        collection.delegate = self
        collection.backgroundColor = ColorManager.shared.background
        return collection
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, AnyHashable>!
    private var baseSnapshot: NSDiffableDataSourceSnapshot<Int, AnyHashable>!
    private var nestedOffersSnapshot = NSDiffableDataSourceSnapshot<Int, Offer>()
    private var nestedCategoriesSnapshot = NSDiffableDataSourceSnapshot<Int, String>()
    
    // MARK: - controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        configureDataSource()
        applySnapshot()
        getMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
        if !isMenuDownloaded {
            preloaderView.startLoadingAnimation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.searchTextField.rightViewMode = .always
        searchBar.setPlaceholderFont(.systemFont(ofSize: 14))
        searchBar.setSideImage(UIImage(named: "Magnifying-glass")!,
                               imageSize: CGSize(width: 18, height: 18),
                               padding: 10,
                               tintColor: ColorManager.shared.label,
                               side: .left)
        
        searchBar.setSideImage(UIImage(named: "Sliders")!,
                               imageSize: CGSize(width: 22, height: 25),
                               padding: 10,
                               tintColor: ColorManager.shared.label,
                               side: .right)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        let notificationButtonImage = UIImage(named: "GotNotification")?.resized(to: CGSize(width: 20, height: 20))
        
        switch traitCollection.userInterfaceStyle {
        case .dark:
            notificationButton.setImage(notificationButtonImage, for: .normal)
        case .light:
            notificationButton.setImage(notificationButtonImage, for: .normal)
        default: return
        }
    }
    
    // MARK: - collection view methods
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, AnyHashable>(collectionView: collectionView) { collectionView, indexPath, item in
            switch indexPath.section {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OffersContainerCell.id, for: indexPath) as? OffersContainerCell
                else { fatalError("Unable deque OffersContainerCell") }
                cell.offersSnapshot = self.nestedOffersSnapshot
                return cell
            case 1:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesContainerCell.id, for: indexPath) as? CategoriesContainerCell
                else { fatalError("Unable deque CategoriesContainerCell") }
                cell.tagSwitchHandler = { [weak self] tag in
                    self?.filterDishes(by: tag)
                }
                cell.categoriesSnapshot = self.nestedCategoriesSnapshot
                return cell
            case 2:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCell.id, for: indexPath) as? DishCell
                else { fatalError("Unable deque DishCell") }
                cell.customShapeView.fillColor = self.dishColors[indexPath.item]
                
                let dish: Dish
                if self.isSearching {
                    dish = self.filteredDishes[indexPath.item]
                } else {
                    dish = self.isFilteredByTag ? self.filteredByTagDishes[indexPath.item] : self.menu.dishes[indexPath.item]
                }
                
                cell.dishData = dish
                return cell
            default:
                return nil
            }
        }
    }
    
    private func applySnapshot() {
        baseSnapshot = NSDiffableDataSourceSnapshot<Int, AnyHashable>()
        baseSnapshot.appendSections([0, 1, 2])
        
        if isSearching {
            baseSnapshot.appendItems(filteredDishes, toSection: 2)
        } else {
            baseSnapshot.appendItems([menu.offersContainer], toSection: 0)
            baseSnapshot.appendItems([menu.categoriesContainer], toSection: 1)
            baseSnapshot.appendItems(isFilteredByTag ? filteredByTagDishes : menu.dishes, toSection: 2)
        }
    
        dataSource.apply(baseSnapshot, animatingDifferences: true)
    }
    
    private func filterDishes(by tag: String) {
        if tag != "All" {
            filteredByTagDishes = menu.dishes.filter { $0.tags.contains(tag) }
            isFilteredByTag = true
        } else {
            isFilteredByTag = false
        }
        applySnapshot()
    }
    
    private func getMenu() {
        Task {
            do {
                let menu = try await NetworkManager.shared.getMenu()
                self.menu = menu
            } catch {
                print("Got some error with network manager: \(error)")
            }
        }
    }
    
    // MARK: - private methods
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.background
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        view.addSubview(headerView)
        view.addSubview(preloaderView)
        
        headerView.addSubview(profilePhotoView)
        headerView.addSubview(pinImageView)
        headerView.addSubview(deliveryAdressLabel)
        headerView.addSubview(notificationButton)
        headerView.addSubview(layoutButton)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: headerHeight),
            
            profilePhotoView.topAnchor.constraint(equalTo: headerView.topAnchor),
            profilePhotoView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            profilePhotoView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
            profilePhotoView.widthAnchor.constraint(equalTo: profilePhotoView.heightAnchor),
            pinImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: -headerBottomPadding / 2),
            pinImageView.leadingAnchor.constraint(equalTo: profilePhotoView.trailingAnchor, constant: 16),
            pinImageView.heightAnchor.constraint(equalToConstant: 20),
            pinImageView.widthAnchor.constraint(equalToConstant: 20),
            layoutButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            layoutButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            layoutButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -headerBottomPadding),
            layoutButton.widthAnchor.constraint(equalTo: layoutButton.heightAnchor),
            notificationButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            notificationButton.trailingAnchor.constraint(equalTo: layoutButton.leadingAnchor, constant: -10),
            notificationButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -headerBottomPadding),
            notificationButton.widthAnchor.constraint(equalTo: notificationButton.heightAnchor),
            deliveryAdressLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: -headerBottomPadding / 2),
            deliveryAdressLabel.leadingAnchor.constraint(equalTo: pinImageView.trailingAnchor, constant: 6),
            deliveryAdressLabel.trailingAnchor.constraint(equalTo: notificationButton.leadingAnchor, constant: -10),
            deliveryAdressLabel.heightAnchor.constraint(equalToConstant: 30),
            
            searchBar.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 54),
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func hideTabBar() {
        isTabBarVisible = false
        let parent = self.parent as! TabBarVC
        parent.hideTabBar()
    }
    
    private func showTabBar() {
        isTabBarVisible = true
        let parent = self.parent as! TabBarVC
        parent.showTabBar()
    }
    
    private func hideSearchBar() {
        UIView.animate(withDuration: 0.2) {
            self.searchBar.transform = CGAffineTransform(translationX: 0, y: -self.searchBar.frame.height)
        }
    }
    
    private func showSearchBar() {
        UIView.animate(withDuration: 0.2) {
            self.searchBar.transform = .identity
        }
    }
    
    func findMatchingByTagDish(referenceDish: Dish) -> [UIImage] {
        let matchingDishes = menu.dishes.filter { dish in
            return !Set(dish.tags).intersection(referenceDish.tags).isEmpty
        }
        
        let selectedDishes = Array(matchingDishes.prefix(3))
        
        var images: [UIImage] = []
        for dish in selectedDishes {
            if let data = dish.imageData, let image = UIImage(data: data) {
                images.append(image)
            }
        }
        
        return images
    }
    
    // MARK: - internal methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y == 0 { return }
        if translation.y > 0 {
            if !isTabBarVisible { showTabBar() }
            if !isSearching { showSearchBar() }
        } else {
            if isTabBarVisible { hideTabBar() }
            if !isSearching { hideSearchBar() }
        }
    }
    
    // MARK: - objc methods
    
    @objc
    private func notificationButtonTaped() {
        getMenu() // for testing
    }
    
    @objc
    private func layoutButtonTaped() {
        preloaderView.switchState() // for testing
    }
}


// MARK: - collection view delegate
extension MenuTabVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chosenDish: Dish
        let cell = collectionView.cellForItem(at: indexPath) as? DishCell
        let color = cell?.customShapeView.fillColor ?? ColorManager.shared.green
        
        if isSearching {
            chosenDish = filteredDishes[indexPath.item]
        } else {
            chosenDish = isFilteredByTag ? filteredByTagDishes[indexPath.item] : menu.dishes[indexPath.item]
        }
        
        let relatedProducts = findMatchingByTagDish(referenceDish: chosenDish)
        let dishPage = DishVC(dish: chosenDish, related: relatedProducts, color: color)
        dishPage.modalTransitionStyle = .coverVertical
        dishPage.modalPresentationStyle = .overFullScreen
        
        present(dishPage, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let offerContainerCell = cell as? OffersContainerCell {
            offerContainerCell.reloadCollectionView()
        }
    }
}


// MARK: - flow layout delegate
extension MenuTabVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: view.frame.width, height: 152)
        case 1:
            return CGSize(width: view.frame.width, height: 38)
        case 2:
            let parentWidth = collectionView.bounds.width
            let itemWidth = (parentWidth / 2 - 24)
            let itemHeight = itemWidth * 1.264
            return CGSize(width: itemWidth, height: itemHeight)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 54, left: 0, bottom: 0, right: 0)
        case 1:
            return UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        case 2:
            return UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}


// MARK: - search methods
extension MenuTabVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredDishes.removeAll()
        } else {
            isSearching = true
            filteredDishes = menu.dishes.filter { dish in
                dish.name.lowercased().contains(searchText.lowercased())
            }
        }
        applySnapshot()
    }
}
