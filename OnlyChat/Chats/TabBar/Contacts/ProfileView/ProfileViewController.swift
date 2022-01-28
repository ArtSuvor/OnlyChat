//
//  ProfileViewController.swift
//  OnlyChat
//
//  Created by Art on 18.01.2022.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
//MARK: - UI
    private let containterView = UIView()
    private let imageView = UIImageView(image: UIImage(named: "human5"), contentMode: .scaleAspectFill)
    private let nameLabel = UILabel(text: "dfgsdfgs", font: .avenir20())
    private let aboutLabel = UILabel(text: "zbnjbzjdfbkzfbz", font: .laoSangam17())
    private let myTextField = InsertableTextField()
    private let user: ModelUser
    
//MARK: - Life cycle
    init(user: ModelUser) {
        self.user = user
        self.nameLabel.text = user.userName
        self.aboutLabel.text = user.description
        
        let imageUrl = URL(string: user.avatarStringURL)
        self.imageView.sd_setImage(with: imageUrl, completed: nil)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
    }
    
//MARK: - SetViews
    private func setView() {
        setupGesture()
        containterView.translatesAutoresizingMaskIntoConstraints = false
        containterView.backgroundColor = .mainWhite()
        containterView.layer.cornerRadius = 30
        imageView.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.numberOfLines = 0
        myTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(containterView)
        containterView.addSubview(nameLabel)
        containterView.addSubview(aboutLabel)
        containterView.addSubview(myTextField)
        
        if let button = myTextField.rightView as? UIButton {
            button.addTarget(self, action: #selector(tappedSendMessage), for: .touchUpInside)
        }
    }
    
    @objc private func tappedSendMessage() {
        guard let message = myTextField.text, message != "" else { return }
        
        FirebaseService.shared.createWaitingChat(message: message, receiver: user) {[weak self] result in
            switch result {
            case .success:
                self?.showAlert(with: "Success", and: "You spent message") {
                    self?.dismiss(animated: true)
                }
            case .failure(let error):
                self?.showAlert(with: "Error", and: error.localizedDescription)
            }
        }
    }
    
//MARK: - Gesture
    private func setupGesture() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tappedView))
        view.addGestureRecognizer(tapGR)
    }
    
    @objc private func tappedView() {
        view.endEditing(true)
    }
}

//MARK: - Constraints
extension ProfileViewController {
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
        
        NSLayoutConstraint.activate([
            myTextField.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 10),
            myTextField.leadingAnchor.constraint(equalTo: containterView.leadingAnchor, constant: 25),
            myTextField.trailingAnchor.constraint(equalTo: containterView.trailingAnchor, constant: -25),
            myTextField.heightAnchor.constraint(equalToConstant: 50)])
    }
}
