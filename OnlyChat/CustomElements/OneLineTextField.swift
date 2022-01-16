//
//  OneLineTextField.swift
//  OnlyChat
//
//  Created by Art on 16.01.2022.
//

import UIKit

class OneLineTextField: UITextField {
    convenience init(font: UIFont? = .avenir20()) {
        self.init()
        self.font = font
        self.borderStyle = .none
        
        let botView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        botView.backgroundColor = .buttonDark()
        botView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(botView)
        
        NSLayoutConstraint.activate([
            botView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            botView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            botView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            botView.heightAnchor.constraint(equalToConstant: 1)])
    }
}
