//
//  UIView+Ext.swift
//  OnlyChat
//
//  Created by Art on 18.01.2022.
//

import UIKit

extension UIView {
    func applyGradients(cornerRadius: CGFloat) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradient = GradientView(from: .topLeading, to: .bottomLeading, startColor: #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1), endColor: #colorLiteral(red: 0.4784313725, green: 0.6980392157, blue: 0.9215686275, alpha: 1))
        if let gradienLayer = gradient.layer.sublayers?.first as? CAGradientLayer {
            gradienLayer.frame = self.bounds
            gradienLayer.cornerRadius = cornerRadius
            self.layer.insertSublayer(gradienLayer, at: 0)
        }
    }
}
