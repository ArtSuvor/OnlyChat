//
//  WaitingChatCell.swift
//  OnlyChat
//
//  Created by Art on 17.01.2022.
//

import UIKit

class WaitingChatCell: UICollectionViewCell, ConfiguringCell {
    
    static var reuseId: String = "WaitingChatCell"
    
//MARK: - UI
    private let friendImageView = UIImageView()
    
//MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
//MARK: - SetViews
    private func setViews() {
        self.layer.shadowColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        friendImageView.layer.cornerRadius = 5
        friendImageView.layer.masksToBounds = true
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(friendImageView)
    }
    
//MARK: - Config
    func configure<U>(with value: U) where U: Hashable {
        guard let value = value as? ChatModel else { return }
//        friendImageView.image = UIImage(named: value.userImageString)
    }
}

//MARK: - Constraints
extension WaitingChatCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            friendImageView.topAnchor.constraint(equalTo: self.topAnchor),
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            friendImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            friendImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
}
