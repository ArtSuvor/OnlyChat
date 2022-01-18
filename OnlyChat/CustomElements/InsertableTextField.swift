//
//  InsertableTextField.swift
//  OnlyChat
//
//  Created by Art on 18.01.2022.
//

import UIKit

class InsertableTextField: UITextField {
    
//MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        createLeftView()
        createRightView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
//MARK: - Override Methods
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 10
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x += -10
        return rect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 35, dy: 0)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 35, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 35, dy: 0)
    }
    
//MARK: - Set View
    private func setViews() {
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 14)
        layer.cornerRadius = 17
        layer.masksToBounds = true
        attributedPlaceholder = NSAttributedString(string: "Write something here...", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
//MARK: - Create LeftView
    private func createLeftView() {
        let image = UIImage(systemName: "smiley")
        let imageView = UIImageView(image: image)
        imageView.setupColor(color: .darkGray)
        
        leftView = imageView
        leftView?.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
        leftViewMode = .always
    }
    
//MARK: - Create RightView
    private func createRightView() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Sent"), for: .normal)
        button.applyGradients(cornerRadius: 10)
        
        rightView = button
        rightView?.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
        rightViewMode = .always
    }
}
