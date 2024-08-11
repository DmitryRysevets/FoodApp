//
//  ProfileTabVC.swift
//  FoodApp
//

import UIKit
import FirebaseAuth

final class ProfileTabVC: UIViewController {
    
    private var user: UserEntity? {
        didSet {
            if let user = user {
                if let name = user.displayName, !name.isEmpty {
                    userName = name
                } else {
                    userName = "User"
                }
            } else {
                userName = "Guest"
            }
            
            avatarImageView.image = DataManager.shared.getUserAvatar()
            tableView.reloadData()
        }
    }
    
    private var userName = "Guest"
    private var addressName: String?
    private var cardName: String?
    
    private let menuItems: [String] = [
        "Account",
        "Delivery Addresses",
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
    
    private lazy var avatarImageView: UIImageView = {
        let image = DataManager.shared.getUserAvatar()
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = ColorManager.shared.label.withAlphaComponent(0.5)
        imageView.backgroundColor = ColorManager.shared.label.withAlphaComponent(0.1)
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarImageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
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
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.addressName = CoreDataManager.shared.getDefaultAddressName()
            self.cardName = CoreDataManager.shared.getPreferredCardName()
            self.user = DataManager.shared.getUser()
        }
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = ColorManager.shared.background
        
        view.addSubview(headerView)
        view.addSubview(avatarImageView)
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
            
            avatarImageView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 120),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor),
            
            tableView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func presentLoginAlert() {
        let alert = UIAlertController(
            title: "Login Required",
            message: "You need to log in to set or change your avatar.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { _ in
            self.navigateToLogin()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func navigateToLogin() {
        let vc = LoginVC()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    // MARK: - Objc methods
    
    @objc
    private func avatarImageViewTapped() {
        if DataManager.shared.isUserLoggedIn() {
            presentImagePicker()
        } else {
            presentLoginAlert()
        }
    }
    
}

// MARK: - UITableViewDelegate

extension ProfileTabVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileMenuCell.id, for: indexPath) as! ProfileMenuCell
        
        switch menuItems[indexPath.row] {
        case "Account":
            cell.extraParameter = userName
        case "Delivery Addresses":
            if let address = addressName {
                cell.extraParameter = address
            } else {
                cell.extraParameter = ">"
            }
        case "Payment Methods":
            if let card = cardName {
                cell.extraParameter = card
            } else {
                cell.extraParameter = ">"
            }
        default:
            cell.extraParameter = ""
        }
        
        cell.menuItemName = menuItems[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let targetVC: UIViewController
        
        switch menuItems[indexPath.row] {
        case "Account":
            targetVC = AccountVC()
        case "Delivery Addresses":
            targetVC = DeliveryAddressesVC()
        case "Payment Methods":
            targetVC = PaymentMethodsVC()
        default: return
        }
        
        targetVC.modalTransitionStyle = .coverVertical
        targetVC.modalPresentationStyle = .fullScreen
        
        present(targetVC, animated: true)
    }
    
}

// MARK: - Picker delegate

extension ProfileTabVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let editedImage = info[.editedImage] as? UIImage else {
            return
        }
        
        Task {
            do {
                try await DataManager.shared.uploadUserAvatar(editedImage)
                avatarImageView.image = editedImage
            } catch {
                print("Failed to upload avatar: \(error)")
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

