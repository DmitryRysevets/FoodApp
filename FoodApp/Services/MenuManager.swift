//
//  MenuManager.swift
//  FoodApp
//

import Foundation

final class MenuManager {

    static let shared = MenuManager()

    private init() {}

    private let coreDataManager = CoreDataManager.shared
    private let firebaseManager = FirebaseManager.shared

    // MARK: - Menu methods
    
    func isLatestMenuInStorage() async -> Bool {
        do {
            let localVersion = coreDataManager.getCurrentMenuVersionNumber()
            let latestVersion = try await firebaseManager.getLatestMenuVersionNumber()
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
                let newMenu = try await firebaseManager.getMenu()
                let latestVersion = try await firebaseManager.getLatestMenuVersionNumber()
                coreDataManager.saveMenu(newMenu, version: latestVersion)
                return newMenu
            }
        } catch {
            print("Error fetching from firestore: \(error)")
            return nil
        }
    }
}
