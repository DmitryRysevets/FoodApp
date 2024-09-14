//
//  UserManager.swift
//  FoodApp
//

import UIKit
import FirebaseAuth

final class UserManager {
    
    static let shared = UserManager()

    private init() {}

    private let coreDataManager = CoreDataManager.shared
    private let networkManager = FirebaseManager.shared
    
    func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func getUser() -> UserEntity? {
        return coreDataManager.fetchUser()
    }
    
    func authenticateUser(email: String, password: String) async throws {
        let user = try await networkManager.authenticateUser(email: email, password: password)
        coreDataManager.saveUser(user)
        
        if let avatarURL = user.photoURL?.absoluteString {
            let avatarData = try await networkManager.downloadImage(from: avatarURL)
            coreDataManager.updateUserAvatar(with: avatarData)
        }
        
        do {
            try await OrderManager.shared.fetchOrderHistory()
        } catch {
            throw error
        }
    }
    
    func registerUser(name: String, email: String, password: String) async throws {
        let user = try await networkManager.registerUser(email: email, password: password)
        coreDataManager.saveUser(user)
        
        if !name.isEmpty {
            try await setUserName(name)
        }
    }
    
    func logoutUser() throws {
        try Auth.auth().signOut()
        coreDataManager.deleteUser()
        coreDataManager.deleteAllOrders()
    }
    
    func setUserName(_ name: String) async throws {
        try await networkManager.setDisplayName(name)
        coreDataManager.setDisplayName(name)
    }
    
    func updateEmail(to newEmail: String, withPassword password: String) async throws {
        try await networkManager.updateEmail(to: newEmail, withPassword: password)
        coreDataManager.updateEmail(newEmail)
    }
    
    func updatePassword(currentPassword: String, to newPassword: String) async throws {
        try await networkManager.updatePassword(currentPassword: currentPassword, to: newPassword)
    }
    
    func getUserAvatar() -> UIImage? {
        if let userEntity = coreDataManager.fetchUser(),
           let avatarData = userEntity.avatar {
            return UIImage(data: avatarData)
        } else {
            return UIImage(named: "Guest")
        }
    }
    
    func uploadUserAvatar(_ image: UIImage) async throws {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }

        let avatarURL = try await networkManager.uploadUserAvatar(imageData)
        coreDataManager.updateUserAvatar(avatarData: imageData, avatarURL: avatarURL.absoluteString)
    }

    func deleteUserAvatar() async throws {
        try await networkManager.deleteUserAvatar()
        coreDataManager.updateUserAvatar(avatarData: nil, avatarURL: nil)
    }
}
