//
//  SetupViewController.swift
//  OnlyChat
//
//  Created by Art on 16.01.2022.
//

import UIKit
import FirebaseAuth

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
    
    private let currentUser: User
    
//MARK: - Life cycle
    init(user: User) {
        self.currentUser = user
        super.init(nibName: nil, bundle: nil)
        
        if let userName = currentUser.displayName {
            fullNameTextField.text = userName
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLogoAndImage()
        setStackView()
        setConstraints()
        addTarget()
    }
    
//MARK: - Methods
    private func setLogoAndImage() {
        fullImageView.translatesAutoresizingMaskIntoConstraints = false
        fullImageView.delegate = self
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
    
    private func addTarget() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGR)
        
        goChatButton.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
    }
    
    @objc private func chatButtonTapped() {
        guard let email = currentUser.email else { return }
        let segmentIndex = sexSegmentedControl.selectedSegmentIndex
        FirebaseService.shared.saveProfileWith(id: currentUser.uid,
                                               email: email,
                                               userName: fullNameTextField.text,
                                               avatarImage: fullImageView.circleImageView.image,
                                               description: aboutTextField.text,
                                               sex: sexSegmentedControl.titleForSegment(at: segmentIndex)) {[weak self] result in
            switch result {
            case .success(let user):
                self?.showAlert(with: "Success", and: "") {
                    self?.present(MainTabBarController(user: user), animated: true)
                }
            case .failure(let error):
                self?.showAlert(with: "Error", and: error.localizedDescription)
            }
        }
    }
    
    @objc private func viewTapped() {
        view.endEditing(true)
    }
}

//MARK: - AddingPhotoUser
extension SetupViewController: AddingPhotoUser {
    func tappedAddButton() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
}

//MARK: - UIImagePickerCOntrollerDelegate
extension SetupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        fullImageView.circleImageView.image = image
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
