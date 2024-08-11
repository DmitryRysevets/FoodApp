//
//  DataManager.swift
//  FoodApp
//

import UIKit
import FirebaseAuth

final class DataManager {
    
    static let shared = DataManager()

    private init() {}
    
    private let coreDataManager = CoreDataManager.shared
    private let networkManager = NetworkManager.shared
    
    // MARK: - Menu methods
    
    func isLatestMenuInStorage() async -> Bool {
        do {
            let localVersion = coreDataManager.getCurrentMenuVersionNumber()
            let latestVersion = try await networkManager.getLatestMenuVersionNumber()
            return localVersion == latestVersion
        } catch {
            print("Error fetching menu version from firestore: \(error)")
            return false
        }
    }
    
    func getLatestMenu() async -> Menu? {
        do {
            let isLatest = await isLatestMenuInStorage()
            if isLatest, let menu = coreDataManager.fetchMenu() {
                return menu
            } else {
                let newMenu = try await networkManager.getMenu()
                let latestVersion = try await networkManager.getLatestMenuVersionNumber()
                coreDataManager.saveMenu(newMenu)
                coreDataManager.setMenuVersion(latestVersion)
                return newMenu
            }
        } catch {
            print("Error fetching from firestore: \(error)")
            return nil
        }
    }
    
    // MARK: - User data methods
    
    func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    }
    
    func getUser() -> UserEntity? {
        return coreDataManager.fetchUser()
    }
    
    func authenticateUser(email: String, password: String) async throws {
        let user = try await networkManager.authenticateUser(email: email, password: password)
        coreDataManager.saveUser(user)
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        
        if let avatarURL = user.photoURL?.absoluteString {
            let avatarData = try await networkManager.downloadImage(from: avatarURL)
            coreDataManager.updateUserAvatar(with: avatarData)
        }
    }
    
    func registerUser(name: String, email: String, password: String) async throws {
        let user = try await networkManager.registerUser(email: email, password: password)
        coreDataManager.saveUser(user)
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        
        if !name.isEmpty {
            try await setUserName(name)
        }
    }
    
    func logoutUser() throws {
        try Auth.auth().signOut()
        coreDataManager.deleteUser()
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
    }
    
    func setUserName(_ name: String) async throws {
        try await NetworkManager.shared.setDisplayName(name)
        CoreDataManager.shared.setDisplayName(name)
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
