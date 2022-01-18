//
//  UIImageView+Ext.swift
//  OnlyChat
//
//  Created by Art on 16.01.2022.
//

import UIKit

extension UIImageView {
    convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
        self.init()
        self.image = image
        self.contentMode = contentMode
    }
    
    func setupColor(color: UIColor) {
        let template = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = template
        self.tintColor = color
    }
}
