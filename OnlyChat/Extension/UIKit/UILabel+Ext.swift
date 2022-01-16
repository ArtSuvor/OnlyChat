//
//  UILabel+Ext.swift
//  OnlyChat
//
//  Created by Art on 16.01.2022.
//

import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont? = .avenir20()) {
        self.init()
        self.text = text
        self.font = font
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
