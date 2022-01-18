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
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        let lower = filter.lowercased()
        return userName.lowercased().contains(lower)
    }
}
