//
//  ChatRequestViewController.swift
//  OnlyChat
//
//  Created by Art on 18.01.2022.
//

import UIKit

class ChatRequestViewController: UIViewController {
    
//MARK: - UI
    private let containterView = UIView()
    private let imageView = UIImageView(image: UIImage(named: "human5"), contentMode: .scaleAspectFill)
    private let nameLabel = UILabel(text: "dfgsdfgs", font: .avenir20())
    private let aboutLabel = UILabel(text: "You have the opportunity to start a new chat.", font: .laoSangam17())
    private let acceptButton = UIButton(title: "Accept", titleColor: .white, backgroundColor: .black, font: .laoSangam20(), isShadow: true, cornerRadius: 10)
    private let denyButton = UIButton(title: "Deny", titleColor: #colorLiteral(red: 0.8352941176, green: 0.2, blue: 0.2, alpha: 1), backgroundColor: .mainWhite(), font: .laoSangam20(), isShadow: true, cornerRadius: 10)
    
//MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        setStackView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        acceptButton.applyGradients(cornerRadius: 10)
    }
    
//MARK: - Set Views
    private func setViews() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containterView.translatesAutoresizingMaskIntoConstraints = false
        containterView.backgroundColor = .white
        containterView.layer.cornerRadius = 30
        
        denyButton.layer.borderColor = #colorLiteral(red: 0.8352941176, green: 0.2, blue: 0.2, alpha: 1)
        denyButton.layer.borderWidth = 1.2
        
        view.addSubview(imageView)
        view.addSubview(containterView)
        containterView.addSubview(nameLabel)
        containterView.addSubview(aboutLabel)
        containterView.addSubview(acceptButton)
        containterView.addSubview(denyButton)
    }
}

//MARK: - Constraints
extension ChatRequestViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            containterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containterView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containterView.heightAnchor.constraint(equalToConstant: 200)])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containterView.topAnchor, constant: 30)])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: containterView.topAnchor, constant: 25),
            nameLabel.leadingAnchor.constraint(equalTo: containterView.leadingAnchor, constant: 25),
            nameLabel.trailingAnchor.constraint(equalTo: containterView.trailingAnchor, constant: -25)])
        
        NSLayoutConstraint.activate([
            aboutLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            aboutLabel.leadingAnchor.constraint(equalTo: containterView.leadingAnchor, constant: 25),
            aboutLabel.trailingAnchor.constraint(equalTo: containterView.trailingAnchor, constant: -25)])
    }
    
//MARK: - Set StackView
    private func setStackView() {
        let buttonStack = UIStackView(arrangedSubviews: [acceptButton, denyButton], axis: .horizontal, spacing: 10)
        buttonStack.distribution = .fillEqually
        containterView.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 25),
            buttonStack.leadingAnchor.constraint(equalTo: containterView.leadingAnchor, constant: 25),
            buttonStack.trailingAnchor.constraint(equalTo: containterView.trailingAnchor, constant: -25)])
    }
}
