//
//  SceneDelegate.swift
//  RxMVVM
//
//  Created by Moataz on 01/01/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let homeVC = homeStoryboard.instantiateViewController(withIdentifier: "home")
            
            window.rootViewController =   homeVC
          
        
            self.window = window
            window.makeKeyAndVisible()
        }
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Handle scene disconnection.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Restart any paused tasks.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Pause active tasks or disable updates.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Undo background changes.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Save data and release shared resources.
    }
}
