//
//  ConfiguringCell.swift
//  OnlyChat
//
//  Created by Art on 17.01.2022.
//

import Foundation

protocol ConfiguringCell {
    static var reuseId: String { get }
    func configure(with value: ChatModel)
}
