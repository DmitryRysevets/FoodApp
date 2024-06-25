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
        
        let tabBarVC = TabBarVC()
        let menuVC = TabBarVC.menuVC
        
        menuVC.view.frame = window.frame
        menuVC.didMove(toParent: tabBarVC)
        tabBarVC.addChild(menuVC)
        tabBarVC.view.addSubview(menuVC.view)
        tabBarVC.view.bringSubviewToFront(tabBarVC.tabBarView)
        
        window.rootViewController = tabBarVC
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

