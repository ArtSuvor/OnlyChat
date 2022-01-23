//
//  LoginViewController.swift
//  OnlyChat
//
//  Created by Art on 16.01.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
//MARK: - UI elements
    private let logoLabel = UILabel(text: "Welcome back!", font: .avenir30())
    private let loginWithLabel = UILabel(text: "Login with")
    private let orLabel = UILabel(text: "or")
    private let emailLabel = UILabel(text: "Email")
    private let passwordLabel = UILabel(text: "Password")
    private let needAccountLabel = UILabel(text: "Need an account?")
    
    private let emailTextField = OneLineTextField(font: .avenir20())
    private let passwordTextField = OneLineTextField(font: .avenir20())
    private var allStackView: UIStackView!
    private var bottomStackView: UIStackView!
    
    private let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .mainWhite(), isShadow: true)
    private let signInButton = UIButton(title: "Sign In", titleColor: .mainWhite(), backgroundColor: .buttonDark())
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.avenir20()
        button.setTitleColor(UIColor.buttonRed(), for: .normal)
        return button
    }()
    
    weak var delegate: AuthNavigationDelegate?
    
//MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        addtargets()
    }
    
//MARK: - Set views
    private func setViews() {
        let loginWithView = ButtonFormView(label: loginWithLabel, button: googleButton)
        let emailStack = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passwordStack = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
        allStackView = UIStackView(arrangedSubviews: [loginWithView, orLabel, emailStack, passwordStack, signInButton], axis: .vertical, spacing: 20)
        signUpButton.contentHorizontalAlignment = .leading
        bottomStackView = UIStackView(arrangedSubviews: [needAccountLabel, signUpButton], axis: .horizontal, spacing: 10)
        bottomStackView.alignment = .firstBaseline
        googleButton.customGoogleButton()
        
        view.backgroundColor = .mainWhite()
        view.addSubview(logoLabel)
        view.addSubview(allStackView)
        view.addSubview(bottomStackView)
    }
    
//MARK: - Add Targets
    private func addtargets() {
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
        view.addGestureRecognizer(tapGR)
    }
    
//MARK: - Objc Methods
    @objc private func signInButtonTapped() {
        AuthService.shared.login(email: emailTextField.text, password: passwordTextField.text) {[weak self] result in
            switch result {
            case .success(let user):
                self?.showAlert(with: "Success!", and: "Welcome back!") {
                    FirebaseService.shared.getUserData(user: user) { result in
                        switch result {
                        case .success(_):
                            self?.present(MainTabBarController(), animated: true)
                        case .failure(_):
                            self?.present(SetupViewController(user: user), animated: true)
                        }
                    }
                }
            case .failure(let error):
                self?.showAlert(with: "Error", and: error.localizedDescription)
            }
        }
    }
    
    @objc private func signUpButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.toSignUpVC()
        }
    }
    
    @objc private func keyboardHide() {
        view.endEditing(true)
    }
}

//MARK: - Constraints
extension LoginViewController {
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
