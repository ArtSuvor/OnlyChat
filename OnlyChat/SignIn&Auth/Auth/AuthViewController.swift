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
    private var stackView: UIStackView!
    
    private let googleLabel = UILabel(text: "Get started with")
    private let emailLabel = UILabel(text: "Or sign up with")
    private let loginLabel = UILabel(text: "Already onboard?")
    
    private let googleButton = UIButton(title: "Google", titleColor: .buttonDark(), backgroundColor: .mainWhite(), isShadow: true)
    private let emailButton = UIButton(title: "Email", titleColor: .mainWhite(), backgroundColor: .buttonDark())
    private let loginButton = UIButton(title: "Login", titleColor: .buttonRed(), backgroundColor: .mainWhite(), isShadow: true)

//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        addTargets()
    }
    
//MARK: - SetViews
    private func setViews() {
        view.backgroundColor = .mainWhite()
        view.addSubview(logoImageView)
        let googleView = ButtonFormView(label: googleLabel, button: googleButton)
        let emailView = ButtonFormView(label: emailLabel, button: emailButton)
        let loginView = ButtonFormView(label: loginLabel, button: loginButton)
        stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView], axis: .vertical, spacing: 40)
        view.addSubview(stackView)
        googleButton.customGoogleButton()
    }
    
//MARK: - Add Targets
    private func addTargets() {
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
//MARK: - Objc Methods
    @objc private func emailButtonTapped() {
        
    }
    
    @objc private func loginButtonTapped() {
        
    }
}

//MARK: - Constaints
extension AuthViewController {
    private func setConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 50)])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)])
    }
}
