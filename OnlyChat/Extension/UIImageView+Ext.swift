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
}
