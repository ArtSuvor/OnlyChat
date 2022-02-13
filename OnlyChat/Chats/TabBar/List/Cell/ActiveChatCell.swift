//
//  ActiveChatCell.swift
//  OnlyChat
//
//  Created by Art on 17.01.2022.
//

import UIKit

class ActiveChatCell: UICollectionViewCell, ConfiguringCell {
    static var reuseId: String = "ActiveCell"
    
//MARK: - UI elements
    private let friendImageView = UIImageView()
    private let friendName = UILabel(text: "User name", font: .laoSangam20())
    private let lastMessage = UILabel(text: "sfhgafia", font: .laoSangam17())
    private let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1), endColor: #colorLiteral(red: 0.4784313725, green: 0.6980392157, blue: 0.9215686275, alpha: 1))
    private let containerView = UIView()
    private let shadowImageView = UIView()
    
//MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
//MARK: - Configure
    func configure<U>(with value: U) where U: Hashable {
        guard let value = value as? ChatModel else { return }
        friendName.text = value.friendUserName
        lastMessage.text = value.lastMessage
        friendImageView.sd_setImage(with: URL(string: value.friendAvatarString))
    }
    
//MARK: - SetUI
    private func setUI() {
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        friendImageView.layer.cornerRadius = 20
        friendImageView.layer.masksToBounds = true

        gradientView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = .white
        
        shadowImageView.translatesAutoresizingMaskIntoConstraints = false
        shadowImageView.layer.shadowColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        shadowImageView.layer.shadowRadius = 2
        shadowImageView.layer.shadowOpacity = 1
        shadowImageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        self.layer.shadowColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        self.addSubview(containerView)
        containerView.addSubview(shadowImageView)
        shadowImageView.addSubview(friendImageView)
        containerView.addSubview(friendName)
        containerView.addSubview(lastMessage)
        containerView.addSubview(gradientView)
    }
}

//MARK: - Constraints
extension ActiveChatCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
        
        NSLayoutConstraint.activate([
            shadowImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            shadowImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            shadowImageView.widthAnchor.constraint(equalToConstant: 70),
            shadowImageView.heightAnchor.constraint(equalToConstant: 70)])
        
        NSLayoutConstraint.activate([
            friendImageView.topAnchor.constraint(equalTo: shadowImageView.topAnchor),
            friendImageView.leadingAnchor.constraint(equalTo: shadowImageView.leadingAnchor),
            friendImageView.trailingAnchor.constraint(equalTo: shadowImageView.trailingAnchor),
            friendImageView.bottomAnchor.constraint(equalTo: shadowImageView.bottomAnchor)])
        
        NSLayoutConstraint.activate([
            friendName.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            friendName.leadingAnchor.constraint(equalTo: shadowImageView.trailingAnchor, constant: 10)])
        
        NSLayoutConstraint.activate([
            lastMessage.topAnchor.constraint(equalTo: friendName.bottomAnchor, constant: 10),
            lastMessage.leadingAnchor.constraint(equalTo: shadowImageView.trailingAnchor, constant: 10),
            lastMessage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)])
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: containerView.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            gradientView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            gradientView.widthAnchor.constraint(equalToConstant: 10)])
    }
}
