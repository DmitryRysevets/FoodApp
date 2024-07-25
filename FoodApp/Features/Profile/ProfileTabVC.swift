//
//  ProfileTabVC.swift
//  FoodApp
//

import UIKit

class ProfileTabVC: UIViewController {
    
    private let menuItems: [String] = [
        "Account", // Name, Mail, Phone Number, Profile Photo
        "Delivery Address",
        "Payment Methods",
        "Order History",
        "Contact Us"
        // Settings (Language, Theme)
        // Privacy
        // Log Out
    ]
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var profileTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.shared.label
        label.font = UIFont.getVariableVersion(of: "Raleway", size: 21, axis: [Constants.fontWeightAxis : 650])
        label.text = "Profile"
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let image = UIImage(named: "Profile2")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        imageView.tintColor = ColorManager.shared.label
        imageView.backgroundColor = ColorManager.shared.label.withAlphaComponent(0.1)
        imageView.layer.cornerRadius = 60
        return imageView
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = ColorManager.shared.background
        table.isScrollEnabled = false
        table.register(ProfileMenuCell.self, forCellReuseIdentifier: ProfileMenuCell.id)
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.background
        
        view.addSubview(headerView)
        view.addSubview(profileImageView)
        view.addSubview(tableView)
        
        headerView.addSubview(profileTitle)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Constants.headerHeight),
            profileTitle.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: -4),
            profileTitle.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            
            tableView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension ProfileTabVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileMenuCell.id, for: indexPath) as! ProfileMenuCell
        cell.menuItemName = menuItems[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let addressPage = DeliveryAddressVC()
            
            addressPage.modalTransitionStyle = .coverVertical
            addressPage.modalPresentationStyle = .fullScreen
            
            present(addressPage, animated: true)
        }
    }
    
}
