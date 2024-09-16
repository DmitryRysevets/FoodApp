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
    private let firebaseManager = FirebaseManager.shared
    
    func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func getUser() -> UserEntity? {
        return coreDataManager.fetchUser()
    }
    
    func authenticateUser(email: String, password: String) async throws {
        let user = try await firebaseManager.authenticateUser(email: email, password: password)
        coreDataManager.saveUser(user)
        
        if let avatarURL = user.photoURL?.absoluteString {
            let avatarData = try await firebaseManager.downloadImage(from: avatarURL)
            coreDataManager.updateUserAvatar(with: avatarData)
        }
        
        do {
            try await OrderManager.shared.fetchOrderHistory()
        } catch {
            throw error
        }
    }
    
    func registerUser(name: String, email: String, password: String) async throws {
        let user = try await firebaseManager.registerUser(email: email, password: password)
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
        try await firebaseManager.setDisplayName(name)
        coreDataManager.setDisplayName(name)
    }
    
    func updateEmail(to newEmail: String, withPassword password: String) async throws {
        try await firebaseManager.updateEmail(to: newEmail, withPassword: password)
        coreDataManager.updateEmail(newEmail)
    }
    
    func updatePassword(currentPassword: String, to newPassword: String) async throws {
        try await firebaseManager.updatePassword(currentPassword: currentPassword, to: newPassword)
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

        let avatarURL = try await firebaseManager.uploadUserAvatar(imageData)
        coreDataManager.updateUserAvatar(avatarData: imageData, avatarURL: avatarURL.absoluteString)
    }

    func deleteUserAvatar() async throws {
        try await firebaseManager.deleteUserAvatar()
        coreDataManager.updateUserAvatar(avatarData: nil, avatarURL: nil)
    }
}
