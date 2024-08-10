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
        do {
            let user = try await networkManager.authenticateUser(email: email, password: password)
            coreDataManager.saveUser(user)
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            
            if let avatarURL = user.photoURL?.absoluteString {
                let avatarData = try await networkManager.downloadImage(from: avatarURL)
                coreDataManager.updateUserAvatar(with: avatarData)
            }
        } catch {
            throw error
        }
    }
    
    func registerUser(email: String, password: String) async throws {
        do {
            let user = try await networkManager.registerUser(email: email, password: password)
            coreDataManager.saveUser(user)
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        } catch {
            throw error
        }
    }
    
    func logoutUser() throws {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
            throw signOutError
        }
        
        coreDataManager.deleteUser()
        
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
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
        guard let userEntity = coreDataManager.fetchUser() else { return }
        guard let userId = userEntity.id else { return }

        let avatarURL = try await networkManager.uploadUserAvatar(imageData, userId: userId)
        coreDataManager.updateUserAvatar(userEntity, avatarData: imageData, avatarURL: avatarURL)
    }

    func deleteUserAvatar() async throws {
        guard let userEntity = coreDataManager.fetchUser() else { return }
        guard let userId = userEntity.id else { return }

        try await networkManager.deleteUserAvatar(userId: userId)
        coreDataManager.updateUserAvatar(userEntity, avatarData: nil, avatarURL: nil)
    }

}
