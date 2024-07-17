//
//  TabBarVC.swift
//  FoodApp
//

import UIKit

final class FavoriteTabVC: UIViewController {
    
    private lazy var content: [CartItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var favoriteTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 21, axis: [Constants.fontWeightAxis : 650])
        label.text = "Favorite"
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = ColorManager.shared.background
        table.separatorStyle = .none
        table.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.id)
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    // MARK: - Empty cart view props.
    
    private lazy var emptyFavoriteView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var favoriteIsEmptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = ColorManager.shared.label
        label.text = "You haven't chosen a favorite yet"
        label.font = UIFont(name: "Raleway", size: 22)
        label.numberOfLines = 1
        label.layer.shadowOffset = CGSize(width: 3, height: 3)
        label.layer.shadowOpacity = 0.2
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 2
        return label
    }()
    
    private lazy var emptyFavoriteImageView: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.background
        
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(emptyFavoriteView)
        
        headerView.addSubview(favoriteTitle)
        emptyFavoriteView.addSubview(favoriteIsEmptyLabel)
        emptyFavoriteView.addSubview(emptyFavoriteImageView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataNotification(_:)), name: NSNotification.Name("DataNotification"), object: nil)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Constants.headerHeight),
            favoriteTitle.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: -4),
            favoriteTitle.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyFavoriteView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 32),
            emptyFavoriteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyFavoriteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyFavoriteView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            favoriteIsEmptyLabel.centerXAnchor.constraint(equalTo: emptyFavoriteView.centerXAnchor),
            favoriteIsEmptyLabel.topAnchor.constraint(equalTo: emptyFavoriteView.topAnchor, constant: 100),
            emptyFavoriteImageView.topAnchor.constraint(equalTo: favoriteIsEmptyLabel.bottomAnchor, constant: 32),
            emptyFavoriteImageView.centerXAnchor.constraint(equalTo: emptyFavoriteView.centerXAnchor),
            emptyFavoriteImageView.heightAnchor.constraint(equalToConstant: 285),
            emptyFavoriteImageView.widthAnchor.constraint(equalToConstant: 255)
        ])
    }
    
    @objc
    private func handleDataNotification(_ notification: Notification) {
        if let data = notification.userInfo?["data"] as? [CartItem] {
//            emptyFavoriteView.isHidden = true
//            tableView.isHidden = false
            content = data
        }
    }
}

// MARK: - TableView delegate methods

extension FavoriteTabVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        content.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == content.count {
            let cell = UITableViewCell()
            cell.backgroundColor = ColorManager.shared.background
            cell.selectionStyle = .none
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.id, for: indexPath) as! FavoriteCell
        cell.favoriteDish = content[indexPath.row].dish
        cell.cartItemImageBackColor = content[indexPath.row].productImageBackColor
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != content.count {
            var relatedProducts: [UIImage] = []
            
            for item in content {
                if let data = item.dish.imageData, let image = UIImage(data: data) {
                    if relatedProducts.count != 3 {
                        relatedProducts.append(image)
                    } else {
                        break
                    }
                }
            }
            
            let dishPage = DishVC(dish: content[indexPath.row].dish,
                                  related: relatedProducts,
                                  color: content[indexPath.row].productImageBackColor)
            
            dishPage.modalTransitionStyle = .coverVertical
            dishPage.modalPresentationStyle = .overFullScreen
            
            present(dishPage, animated: true)
        }
    }
}
