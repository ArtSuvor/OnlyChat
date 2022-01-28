//
//  MessageModel.swift
//  OnlyChat
//
//  Created by Art on 28.01.2022.
//

import UIKit

struct MessageModel: Hashable {
    let content: String
    let senderId: String
    let senderName: String
    let sentDate: Date
    let id: String?
    
    var representation: [String: Any] {
        let rep: [String: Any] = [
            "created": sentDate,
            "senderId": senderId,
            "senderName": senderName,
            "content": content]
        return rep
    }
    
    init(user: ModelUser, content: String) {
        self.senderId = user.id
        self.senderName = user.userName
        self.sentDate = Date()
        self.id = nil
        self.content = content
    }
}
