//
//  SignUpViewController.swift
//  OnlyChat
//
//  Created by Art on 16.01.2022.
//

import UIKit

class SignUpViewController: UIViewController {
    
//MARK: - UI elements
    private let logoLabel = UILabel(text: "Hello World", font: .avenir30())
    private let emailLabel = UILabel(text: "Email")
    private let passwordLabel = UILabel(text: "Password")
    private let confirmPassLabel = UILabel(text: "Confirm Password")
    private let alreadyLabel = UILabel(text: "Already onboard?")
    
    private let emailTextField = OneLineTextField(font: .avenir20())
    private let passwordTextField = OneLineTextField(font: .avenir20())
    private let confirmPasTextField = OneLineTextField(font: .avenir20())
    
    private var allStackView: UIStackView!
    private var bottomStackView: UIStackView!
    
    private let signUpButton = UIButton(title: "Sign Up", titleColor: .mainWhite(), backgroundColor: .buttonDark())
    private let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.avenir20()
        button.setTitleColor(UIColor.buttonRed(), for: .normal)
        return button
    }()
    
//MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setStackView()
        setConstraints()
    }
}

//MARK: - Set View and Constraints
extension SignUpViewController {
    private func setStackView() {
        let emailStack = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passwordStack = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
        let confirmPasStack = UIStackView(arrangedSubviews: [confirmPassLabel, confirmPasTextField], axis: .vertical, spacing: 0)
        loginButton.contentHorizontalAlignment = .leading
        bottomStackView = UIStackView(arrangedSubviews: [alreadyLabel, loginButton], axis: .horizontal, spacing: 10)
        bottomStackView.alignment = .firstBaseline

        allStackView = UIStackView(arrangedSubviews: [emailStack, passwordStack, confirmPasStack, signUpButton], axis: .vertical, spacing: 20)
        view.addSubview(logoLabel)
        view.addSubview(allStackView)
        view.addSubview(bottomStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            logoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        NSLayoutConstraint.activate([
            allStackView.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 50),
            allStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            allStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)])
        
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: allStackView.bottomAnchor, constant: 50),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)])
    }
}

//MARK: - SwiftUI
import SwiftUI

struct SignUpViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let viewController = SignUpViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
