//
//  TabBarVC.swift
//  FoodApp
//

import UIKit

final class FavoriteTabVC: UIViewController {
    
    private lazy var favoriteDishes: [Dish] = [] {
        didSet {
            tableView.reloadData()
            
            if dishColors.count != favoriteDishes.count {
                dishColors = ColorManager.shared.getColors(favoriteDishes.count)
            }
            
            if favoriteDishes.isEmpty {
                emptyFavoriteView.isHidden = false
                tableView.isHidden = true
            } else {
                emptyFavoriteView.isHidden = true
                tableView.isHidden = false
            }
        }
    }
    
    private var dishColors: [UIColor] = []

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
        table.isHidden = true
        return table
    }()
    
    // MARK: - Empty cart view props.
    
    private lazy var emptyFavoriteView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
        let image = UIImage(named: "EmptyFavorite")
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
    
    override func viewWillAppear(_ animated: Bool) {
        let favorite = CoreDataManager.shared.fetchFavorites()
        if favoriteDishes != favorite {
            favoriteDishes = favorite
        }
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
            emptyFavoriteImageView.topAnchor.constraint(equalTo: favoriteIsEmptyLabel.bottomAnchor, constant: 47),
            emptyFavoriteImageView.centerXAnchor.constraint(equalTo: emptyFavoriteView.centerXAnchor),
            emptyFavoriteImageView.heightAnchor.constraint(equalToConstant: 270),
            emptyFavoriteImageView.widthAnchor.constraint(equalToConstant: 255)
        ])
    }
}

// MARK: - TableView delegate methods

extension FavoriteTabVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteDishes.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == favoriteDishes.count {
            let cell = UITableViewCell()
            cell.backgroundColor = ColorManager.shared.background
            cell.selectionStyle = .none
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.id, for: indexPath) as! FavoriteCell
        cell.favoriteDish = favoriteDishes[indexPath.row]
        cell.cartItemImageBackColor = dishColors[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != favoriteDishes.count {
            var relatedProducts: [UIImage] = []
            
            for item in favoriteDishes {
                if let data = item.imageData, let image = UIImage(data: data) {
                    if relatedProducts.count != 3 {
                        relatedProducts.append(image)
                    } else {
                        break
                    }
                }
            }
            
            let dishPage = DishVC(dish: favoriteDishes[indexPath.row], color: dishColors[indexPath.row])
            
            dishPage.modalTransitionStyle = .coverVertical
            dishPage.modalPresentationStyle = .fullScreen
            
            present(dishPage, animated: true)
        }
    }
}
