//
//  ModelUser.swift
//  OnlyChat
//
//  Created by Art on 17.01.2022.
//

import Foundation

struct ModelUser: Hashable, Decodable {
    let id: String
    let userName: String
    let avatarStringURL: String
    let email: String
    let description: String
    let sex: String
    
    var representation: [String: Any] {
        var rep = ["uid": id]
        rep["userName"] = userName
        rep["email"] = email
        rep["avatarStringUrl"] = avatarStringURL
        rep["description"] = description
        rep["sex"] = sex
        return rep
    }
    
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
