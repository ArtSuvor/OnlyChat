//
//  ButtonFormView.swift
//  OnlyChat
//
//  Created by Art on 16.01.2022.
//

import UIKit

class ButtonFormView: UIView {
    
    init(label: UILabel, button: UIButton) {
        super.init(frame: .zero)
        self.addSubview(label)
        self.addSubview(button)
        setConstraints(label: label, button: button)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setConstraints(label: UILabel, button: UIButton) {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor)])
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
}
