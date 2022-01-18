//
//  SceneDelegate.swift
//  OnlyChat
//
//  Created by Art on 16.01.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.windowScene = windowScene
        window.rootViewController = ProfileViewController()
        window.makeKeyAndVisible()
        self.window = window
    }
}
