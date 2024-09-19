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
    
    func isLatestMenuDownloaded() async throws -> Bool {
        let localVersion = try coreDataManager.getCurrentMenuVersionNumber()
        let latestVersion = try await firebaseManager.getLatestMenuVersionNumber()
        return localVersion == latestVersion
    }
    
    func getLatestMenu() async throws -> Menu {
        async let fetchedMenu = firebaseManager.getMenu()
        async let latestVersion = firebaseManager.getLatestMenuVersionNumber()
        
        let menu = try await fetchedMenu
        let version = try await latestVersion
        
        try coreDataManager.saveMenu(menu, version: version)
        
        return menu
    }

}
