//
//  TabBarVC.swift
//  FoodApp
//

import UIKit

final class MenuTabVC: UIViewController {
    
    private lazy var preloaderView = PreloaderView(frame: CGRect(x: 32, y: Int(view.center.y - 100), width: Int(view.frame.width - 64), height: 180))
    
    // MARK: - header vars.
    
    private let headerHeight = 44.0
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var profilePhotoView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "Profile")?.resized(to: CGSize(width: 18, height: 23))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = image
        view.contentMode = .center
        view.tintColor = ColorManager.shared.label
        view.backgroundColor = ColorManager.shared.secondaryGrey
        view.layer.cornerRadius = headerHeight / 2
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
        button.backgroundColor = ColorManager.shared.secondaryGrey
        button.layer.cornerRadius = headerHeight / 2
        button.addTarget(self, action: #selector(notificationButtonTaped), for: .touchUpInside)
        return button
    }()
    
    private lazy var layoutButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Layout")?.resized(to: CGSize(width: 20, height: 20))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image?.withTintColor(ColorManager.shared.label), for: .normal)
        button.backgroundColor = ColorManager.shared.secondaryGrey
        button.layer.cornerRadius = headerHeight / 2
        button.addTarget(self, action: #selector(layoutButtonTaped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - search bar vars.
    
    //    private lazy var searchController: UISearchController = {
    //        let controller = UISearchController(searchResultsController: nil)
    //        controller.searchResultsUpdater = self
    //        controller.obscuresBackgroundDuringPresentation = false
    //        controller.searchBar.placeholder = "Search"
    //        navigationItem.searchController = controller
    //        definesPresentationContext = true
    //        return controller
    //    }()
    //
    //    private var filteredResults = [Dish]()
    //
    //    private var searchBarIsEmpty: Bool {
    //        guard let text = searchController.searchBar.text else { return false }
    //        return text.isEmpty
    //    }
    
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
        }
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, AnyHashable>!
    private var baseSnapshot: NSDiffableDataSourceSnapshot<Int, AnyHashable>!
    private var nestedOffersSnapshot = NSDiffableDataSourceSnapshot<Int, Offer>()
    private var nestedCategoriesSnapshot = NSDiffableDataSourceSnapshot<Int, String>()
    
    private var offerColors: [UIColor] = []
    private var dishColors: [UIColor] = []
    
    private var isMenuDownloaded = false
    private var tabBarIsVisible = true
    
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
                cell.categoriesSnapshot = self.nestedCategoriesSnapshot
                return cell
            case 2:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCell.id, for: indexPath) as? DishCell
                else { fatalError("Unable deque DishCell") }
                cell.customShapeView.fillColor = self.dishColors[indexPath.item]
                cell.dishData = self.menu.dishes[indexPath.item]
                return cell
            default:
                return nil
            }
        }
    }
    
    private func applySnapshot() {
        baseSnapshot = NSDiffableDataSourceSnapshot<Int, AnyHashable>()
        baseSnapshot.appendSections([0, 1, 2])
        baseSnapshot.appendItems([menu.offersContainer], toSection: 0)
        baseSnapshot.appendItems([menu.categoriesContainer], toSection: 1)
        baseSnapshot.appendItems(menu.dishes, toSection: 2)
        dataSource.apply(baseSnapshot, animatingDifferences: true)
    }
    
    // MARK: - controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        configureDataSource()
        applySnapshot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
        if !isMenuDownloaded {
            preloaderView.startLoadingAnimation()
        }
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
    
    // MARK: - private methods
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.background
        view.addSubview(headerView)
        view.addSubview(collectionView)
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
            profilePhotoView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            profilePhotoView.widthAnchor.constraint(equalTo: profilePhotoView.heightAnchor),
            pinImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            pinImageView.leadingAnchor.constraint(equalTo: profilePhotoView.trailingAnchor, constant: 16),
            pinImageView.heightAnchor.constraint(equalToConstant: 20),
            pinImageView.widthAnchor.constraint(equalToConstant: 20),
            layoutButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            layoutButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            layoutButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            layoutButton.widthAnchor.constraint(equalTo: layoutButton.heightAnchor),
            notificationButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            notificationButton.trailingAnchor.constraint(equalTo: layoutButton.leadingAnchor, constant: -10),
            notificationButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            notificationButton.widthAnchor.constraint(equalTo: notificationButton.heightAnchor),
            deliveryAdressLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            deliveryAdressLabel.leadingAnchor.constraint(equalTo: pinImageView.trailingAnchor, constant: 6),
            deliveryAdressLabel.trailingAnchor.constraint(equalTo: notificationButton.leadingAnchor, constant: -10),
            deliveryAdressLabel.heightAnchor.constraint(equalToConstant: 30),
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func performTabBarCheck(with translation: CGPoint) {
        if translation.y == 0 { return }
        if translation.y > 0 {
            if !tabBarIsVisible { showTabBar() }
        } else {
            if tabBarIsVisible { hideTabBar() }
        }
    }
    
    private func hideTabBar() {
        self.tabBarIsVisible = false
        let parent = self.parent as! TabBarVC
        parent.hideTabBar()
    }
    
    private func showTabBar() {
        self.tabBarIsVisible = true
        let parent = self.parent as! TabBarVC
        parent.showTabBar()
    }
    
    // MARK: - internal methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        performTabBarCheck(with: translation)
    }
    
    // MARK: - objc methods
    
    @objc
    private func notificationButtonTaped() {
        // for testing
        Task {
            do {
                let result = try await NetworkManager.shared.getMenu()
                let menu = Menu(offers: result.offers, dishes: result.dishes)
                self.menu = menu
            } catch {
                print("We got some shit: \(error)")
            }
        }
    }
    
    @objc
    private func layoutButtonTaped() {
        // for testing
        preloaderView.switchState()
    }
}

// MARK: - collection view delegate
extension MenuTabVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case 1:
            return UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
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
extension MenuTabVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
