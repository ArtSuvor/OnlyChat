//
//  ViewController.swift
//  OnlyChat
//
//  Created by Art on 16.01.2022.
//

import UIKit

class AuthViewController: UIViewController {
    
//MARK: - UI elements
    private let logoImageView = UIImageView(image: UIImage(named: "chat"), contentMode: .scaleAspectFit)
    
    private let googleLabel = UILabel(text: "Get started with")
    private let emailLabel = UILabel(text: "Or sign up with")
    private let loginLAbel = UILabel(text: "Already onboard?")
    
    private let googleButton = UIButton(title: "Google", titleColor: .buttonDark(), backgroundColor: .mainWhite(), isShadow: true)
    private let emailButton = UIButton(title: "Email", titleColor: .mainWhite(), backgroundColor: .buttonDark())
    private let loginButton = UIButton(title: "Login", titleColor: .buttonRed(), backgroundColor: .mainWhite(), isShadow: true)

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    private func setViews() {
        view.addSubview(googleButton)
        view.addSubview(emailButton)
        view.addSubview(loginButton)
    }
}

//MARK: - SwiftUI

import SwiftUI

struct AuthViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let viewController = AuthViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
