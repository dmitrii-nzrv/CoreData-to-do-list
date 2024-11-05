//
//  SceneDelegate.swift
//  CoreData-to-do-list
//
//  Created by Dmitrii Nazarov on 03.11.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: scene as! UIWindowScene)
        window?.rootViewController = UINavigationController(rootViewController: MainViewController())
        window?.makeKeyAndVisible()
    }

  
}

