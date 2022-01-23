//
//  MainTabBarController.swift
//  OnlyChat
//
//  Created by Art on 17.01.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    private let currentUser: ModelUser
    
    init(user: ModelUser = ModelUser(id: "", name: "", email: "", description: "", sex: "", avatarStringUrl: "")) {
        self.currentUser = user
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contactsVC = ContactsViewController(user: currentUser)
        let listVC = ListViewController(user: currentUser)
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
