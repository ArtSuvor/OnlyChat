//
//  ChatModel.swift
//  OnlyChat
//
//  Created by Art on 17.01.2022.
//

import Foundation

struct ChatModel: Hashable, Decodable {
    let friendUserName: String
    let friendAvatarString: String
    let lastMessage: String
    let friendId: String
    
    var representation: [String: Any] {
        var rep = ["friendUserName": friendUserName]
        rep["friendAvatarString"] = friendAvatarString
        rep["friendId"] = friendId
        rep["lastMessage"] = lastMessage
        return rep
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    
    static func == (lhs: ChatModel, rhs: ChatModel) -> Bool {
        lhs.friendId == rhs.friendId
    }
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        let lower = filter.lowercased()
        return friendUserName.lowercased().contains(lower)
    }
}
