//
//  ActiveChatCell.swift
//  OnlyChat
//
//  Created by Art on 17.01.2022.
//

protocol ConfiguringCell {
    static var reuseId: String { get }
    func configure(with value: ChatModel)
}

import UIKit

class ActiveChatCell: UICollectionViewCell, ConfiguringCell {
    static var reuseId: String = "ActiveCell"
    
//MARK: - UI elements
    private let friendImageView = UIImageView()
    private let friendName = UILabel(text: "User name", font: .laoSangam20())
    private let lastMessage = UILabel(text: "sfhgafia", font: .laoSangam17())
    private let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1), endColor: #colorLiteral(red: 0.4784313725, green: 0.6980392157, blue: 0.9215686275, alpha: 1))
    
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
    func configure(with value: ChatModel) {
        friendImageView.image = UIImage(named: value.userImageString)
        friendName.text = value.userName
        lastMessage.text = value.lastMessage
    }
    
//MARK: - SetUI
    private func setUI() {
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        friendImageView.backgroundColor = .gray
        friendImageView.layer.cornerRadius = 20
        friendImageView.layer.masksToBounds = true
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.backgroundColor = .black
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.backgroundColor = .white
        
        self.addSubview(friendImageView)
        self.addSubview(friendName)
        self.addSubview(lastMessage)
        self.addSubview(gradientView)
    }
}

//MARK: - Constraints
extension ActiveChatCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            friendImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            friendImageView.widthAnchor.constraint(equalToConstant: 70),
            friendImageView.heightAnchor.constraint(equalToConstant: 70)])
        
        NSLayoutConstraint.activate([
            friendName.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            friendName.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 10)])
        
        NSLayoutConstraint.activate([
            lastMessage.topAnchor.constraint(equalTo: friendName.bottomAnchor, constant: 10),
            lastMessage.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 10),
            lastMessage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)])
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: self.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gradientView.widthAnchor.constraint(equalToConstant: 10)])
    }
}
