//
//  GradientView.swift
//  OnlyChat
//
//  Created by Art on 17.01.2022.
//

import UIKit

class GradientView: UIView {
    
//MARK: - Enum for gradient
    enum Point {
        case topLeading
        case leading
        case bottomLeading
        case top
        case center
        case bottom
        case topTrailing
        case trailing
        case bottomTrailing
        
        var point: CGPoint {
            switch self {
            case .topLeading: return CGPoint(x: 0, y: 0)
            case .leading: return CGPoint(x: 0, y: 0.5)
            case .bottomLeading: return CGPoint(x: 0, y: 1.0)
            case .top: return CGPoint(x: 0.5, y: 0)
            case .center: return CGPoint(x: 0.5, y: 0.5)
            case .bottom: return CGPoint(x: 0.5, y: 1.0)
            case .topTrailing: return CGPoint(x: 1.0, y: 0)
            case .trailing: return CGPoint(x: 1.0, y: 0.5)
            case .bottomTrailing: return CGPoint(x: 1.0, y: 1.0)
            }
        }
    }
    
    private let gradient = CAGradientLayer()
    
    convenience init(from: Point, to: Point, startColor: UIColor?, endColor: UIColor?) {
        self.init()
        setGradient(from: from, to: to, startColor: startColor, endColor: endColor)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = self.bounds
    }
    
    private func setGradient(from: Point, to: Point, startColor: UIColor?, endColor: UIColor?) {
        self.layer.addSublayer(gradient)
        setGradientColors(startColor: startColor, endColor: endColor)
        gradient.startPoint = from.point
        gradient.endPoint = to.point
    }
    
    private func setGradientColors(startColor: UIColor?, endColor: UIColor?) {
        if let start = startColor,
           let end = endColor {
            gradient.colors = [start.cgColor, end.cgColor]
        }
    }
}
