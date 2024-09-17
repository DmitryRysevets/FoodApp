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
        let menu = try await firebaseManager.getMenu()
        let latestVersion = try await firebaseManager.getLatestMenuVersionNumber()
        try coreDataManager.saveMenu(menu, version: latestVersion)
        return menu
    }
}
