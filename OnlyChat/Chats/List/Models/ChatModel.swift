//
//  ChatModel.swift
//  OnlyChat
//
//  Created by Art on 17.01.2022.
//

import Foundation

struct ChatModel: Hashable, Decodable {
    let userName: String
    let userImageString: String
    let lastMessage: String
    let id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ChatModel, rhs: ChatModel) -> Bool {
        lhs.id == rhs.id
    }
}
