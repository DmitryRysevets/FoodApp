//
//  DataManager.swift
//  FoodApp
//

import Foundation
import FirebaseAuth

final class DataManager {
    
    static let shared = DataManager()

    private init() {}
    
    private let coreDataManager = CoreDataManager.shared
    private let networkManager = NetworkManager.shared
    
    // MARK: - Menu methods
    
    func isLatestMenuInStorage() async -> Bool {
        do {
            let localVersion = coreDataManager.getMenuVersion()
            let latestVersion = try await networkManager.getLatestMenuVersion()
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
                let latestVersion = try await networkManager.getLatestMenuVersion()
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
    
    func authenticateUser(email: String, password: String) async throws {
        do {
            let user = try await networkManager.authenticateUser(email: email, password: password)
            coreDataManager.saveUser(user)
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
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

    func logoutUser() {
        if let userEntity = coreDataManager.fetchUser() {
            coreDataManager.deleteUser(userEntity)
        }
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
    }

    func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    }

    func getUser() -> UserEntity? {
        return coreDataManager.fetchUser()
    }
}
