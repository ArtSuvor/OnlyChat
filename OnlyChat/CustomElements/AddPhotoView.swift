//
//  AddPhotoView.swift
//  OnlyChat
//
//  Created by Art on 16.01.2022.
//

import UIKit

class AddPhotoView: UIView {
    
//MARK: - UI elements
    var circleImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "avatar")
        view.contentMode = .scaleAspectFill
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
    }()
    
    private let addedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.tintColor = .buttonDark()
        return button
    }()
    
//MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
//MARK: - Set Views
    private func setViews() {
        addSubview(circleImageView)
        addSubview(addedButton)
        
        NSLayoutConstraint.activate([
            circleImageView.topAnchor.constraint(equalTo: self.topAnchor),
            circleImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            circleImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            circleImageView.widthAnchor.constraint(equalToConstant: 100),
            circleImageView.heightAnchor.constraint(equalToConstant: 100)])
        
        NSLayoutConstraint.activate([
            addedButton.leadingAnchor.constraint(equalTo: circleImageView.trailingAnchor, constant: 15),
            addedButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addedButton.widthAnchor.constraint(equalToConstant: 30),
            addedButton.heightAnchor.constraint(equalToConstant: 30)])
    }
}
