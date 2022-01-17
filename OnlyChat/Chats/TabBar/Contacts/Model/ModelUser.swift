//
//  ModelUser.swift
//  OnlyChat
//
//  Created by Art on 17.01.2022.
//

import Foundation

struct ModelUser: Hashable, Decodable {
    let userName: String
    let avatarStringURL: String
    let id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ModelUser, rhs: ModelUser) -> Bool {
        lhs.id == rhs.id
    }
}
