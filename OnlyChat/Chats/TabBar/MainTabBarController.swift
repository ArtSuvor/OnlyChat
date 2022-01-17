//
//  MainTabBarController.swift
//  OnlyChat
//
//  Created by Art on 17.01.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contactsVC = ContactsViewController()
        let listVC = ListViewController()
        viewControllers = setViewControllers(first: contactsVC, second: listVC)
        tabBar.tintColor = #colorLiteral(red: 0.5568627451, green: 0.3529411765, blue: 0.968627451, alpha: 1)
    }
    
    private func generateNavigationController(root: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: root)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
    
    private func setViewControllers(first: UIViewController, second: UIViewController) -> [UIViewController] {
        let boldConfiguration = UIImage.SymbolConfiguration(weight: .medium)
        let firstImage = UIImage(systemName: "person.2", withConfiguration: boldConfiguration)
        let secondImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfiguration)
        let firstTitle = "Contacts"
        let secondTitle = "Conversations"
        let viewControllers = [
        generateNavigationController(root: first, title: firstTitle, image: firstImage!),
        generateNavigationController(root: second, title: secondTitle, image: secondImage!)]
        return viewControllers
    }
}
