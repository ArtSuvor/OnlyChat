//
//  ContactsCell.swift
//  OnlyChat
//
//  Created by Art on 17.01.2022.
//

import UIKit
import SDWebImage

class ContactsCell: UICollectionViewCell, ConfiguringCell {
    static var reuseId: String = "ContactsCell"
    
//MARK: - UI
    private let userImageView = UIImageView()
    private let userNameLabel = UILabel(text: "text", font: .laoSangam20())
    
//MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstaints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
//MARK: - Config
    func configure<U>(with value: U) where U: Hashable {
        guard let value = value as? ModelUser else { return }
        userNameLabel.text = value.userName
        
        let imageUrl = URL(string: value.avatarStringURL)
        userImageView.sd_setImage(with: imageUrl, completed: nil)
    }
    
//MARK: - SetUI
    private func setViews() {
        userImageView.layer.cornerRadius = 5
        userImageView.layer.masksToBounds = true
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.layer.shadowColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        self.addSubview(userImageView)
        self.addSubview(userNameLabel)
    }
}

//MARK: - Constaints
extension ContactsCell {
    private func setConstaints() {
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: self.topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            userImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            userImageView.heightAnchor.constraint(equalTo: self.widthAnchor)])
        
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            userNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            userNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
}
