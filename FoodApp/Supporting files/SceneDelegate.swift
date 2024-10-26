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

    func switchRootViewController(to viewController: UIViewController, animated: Bool = true) {
        guard let window = self.window else { return }
        
        UserDefaults.standard.set(false, forKey: "isFirstLaunch")
        
        if animated {
            window.addSubview(viewController.view)
            viewController.view.transform = CGAffineTransform(translationX: window.bounds.width, y: 0)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0.5, animations: {
                    viewController.view.transform = .identity
                }, completion: { _ in
                    window.rootViewController = viewController
                    window.makeKeyAndVisible()
            })
        } else {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
    }

}

