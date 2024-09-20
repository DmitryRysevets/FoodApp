//
//  AppDelegate.swift
//  FoodApp
//

import UIKit
import FirebaseCore
import CoreData
import GoogleMaps

@main

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        GMSServices.provideAPIKey("YOUR_API_KEY")
        
        FirebaseApp.configure()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        do {
            try CoreDataManager.shared.saveContext()
        } catch {
            // need handler
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }


}

