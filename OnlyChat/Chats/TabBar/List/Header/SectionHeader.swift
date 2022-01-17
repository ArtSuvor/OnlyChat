//
//  SectionHeader.swift
//  OnlyChat
//
//  Created by Art on 17.01.2022.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    static let reuseId = "SectionHeader"
    
    private let title = UILabel(text: "", font: .avenir20())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configTitle(text: String, font: UIFont?, textColor: UIColor) {
        title.text = text
        title.font = font
        title.textColor = textColor
    }
    
    private func setTitle() {
        self.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            title.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
}
