//
//  SceneDelegate.swift
//  FoodApp
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let initialVC: UIViewController
        
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "isFirstLaunch") == nil {
            defaults.set(true, forKey: "isFirstLaunch")
        }
        
        let isFirstLaunch = defaults.bool(forKey: "isFirstLaunch")
        
        if isFirstLaunch {
            initialVC = GreetingVC()
        } else {
            let tabBarVC = TabBarVC()
            tabBarVC.initialSetup(with: window.frame)
            initialVC = tabBarVC
        }
        
        window.rootViewController = initialVC
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }


}

