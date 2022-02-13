//
//  ChatModel.swift
//  OnlyChat
//
//  Created by Art on 17.01.2022.
//

import Foundation
import FirebaseFirestore

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
    
    init(friendUserName: String,  friendAvatarString: String, lastMessage: String, friendId: String) {
        self.friendUserName = friendUserName
        self.friendAvatarString = friendAvatarString
        self.friendId = friendId
        self.lastMessage = lastMessage
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        guard let userName = data["friendUserName"] as? String,
              let avatar = data["friendAvatarString"] as? String,
              let id = data["friendId"] as? String,
              let lastMessage = data["lastMessage"] as? String else { return nil}
        self.friendUserName = userName
        self.friendAvatarString = avatar
        self.friendId = id
        self.lastMessage = lastMessage
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
