//
//  DataManager.swift
//  FoodApp
//

import UIKit

final class DataManager {
    
    static let shared = DataManager()

    private init() {}
    
    func isLatestMenuInStorage() async -> Bool {
        do {
            let localVersion = CoreDataManager.shared.getMenuVersion()
            let latestVersion = try await NetworkManager.shared.getLatestMenuVersion()
            return localVersion == latestVersion
        } catch {
            print("Error fetching menu version from firestore: \(error)")
            return false
        }
    }
    
    func getLatestMenu() async -> Menu? {
        do {
            let isLatest = await isLatestMenuInStorage()
            if isLatest, let menu = CoreDataManager.shared.fetchMenu() {
                return menu
            } else {
                let newMenu = try await NetworkManager.shared.getMenu()
                let latestVersion = try await NetworkManager.shared.getLatestMenuVersion()
                CoreDataManager.shared.saveMenu(newMenu)
                CoreDataManager.shared.setMenuVersion(latestVersion)
                return newMenu
            }
        } catch {
            print("Error fetching from firestore: \(error)")
            return nil
        }
    }
}
