//
//  SetupViewController.swift
//  OnlyChat
//
//  Created by Art on 16.01.2022.
//

import UIKit

class SetupViewController: UIViewController {
    
//MARK: - UI elements
    private let logoLabel = UILabel(text: "Set up profile!", font: .avenir30())
    private let fullImageView = AddPhotoView()
    private let fullNameLabel = UILabel(text: "Full name")
    private let aboutLabel = UILabel(text: "About me")
    private let sexLabel = UILabel(text: "Sex")

    private let fullNameTextField = OneLineTextField(font: .avenir20())
    private let aboutTextField = OneLineTextField(font: .avenir20())
    private var allStackView: UIStackView!
    
    private let sexSegmentedControl = UISegmentedControl(first: "Male", second: "Female")
    private let goChatButton = UIButton(title: "Go to chat`s", titleColor: .mainWhite(), backgroundColor: .buttonDark())
    
//MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLogoAndImage()
        setStackView()
        setConstraints()
    }
    
//MARK: - Methods
    private func setLogoAndImage() {
        fullImageView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mainWhite()
        view.addSubview(logoLabel)
        view.addSubview(fullImageView)
    }
    
    private func setStackView() {
        let fullNameStack = UIStackView(arrangedSubviews: [fullNameLabel, fullNameTextField], axis: .vertical, spacing: 0)
        let aboutStackView = UIStackView(arrangedSubviews: [aboutLabel, aboutTextField], axis: .vertical, spacing: 0)
        let sexStackView = UIStackView(arrangedSubviews: [sexLabel, sexSegmentedControl], axis: .vertical, spacing: 10)
        allStackView = UIStackView(arrangedSubviews: [fullNameStack, aboutStackView, sexStackView, goChatButton], axis: .vertical, spacing: 30)
        
        view.addSubview(allStackView)
    }
}

//MARK: - Constraints
extension SetupViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            logoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        NSLayoutConstraint.activate([
            fullImageView.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 50),
            fullImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        NSLayoutConstraint.activate([
            allStackView.topAnchor.constraint(equalTo: fullImageView.bottomAnchor, constant: 50),
            allStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            allStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)])
    }
}
