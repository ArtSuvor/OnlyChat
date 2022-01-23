//
//  SceneDelegate.swift
//  OnlyChat
//
//  Created by Art on 16.01.2022.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.windowScene = windowScene
        if let user = Auth.auth().currentUser {
            FirebaseService.shared.getUserData(user: user) { [weak self] result in
                switch result {
                case .success(let user):
                    self?.window?.rootViewController = MainTabBarController(user: user)
                case .failure(let error):
                    print(error)
                    self?.window?.rootViewController = AuthViewController()
                }
            }
        } else {
            window.rootViewController = AuthViewController()
        }
        window.makeKeyAndVisible()
        self.window = window
    }
}
