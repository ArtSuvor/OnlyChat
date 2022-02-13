//
//  MessageModel.swift
//  OnlyChat
//
//  Created by Art on 28.01.2022.
//

import UIKit
import FirebaseFirestore

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
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        guard let sentDate = data["created"] as? Timestamp,
              let senderId = data["senderId"] as? String,
              let senderName = data["senderName"] as? String,
              let content = data["content"] as? String else { return nil }
        
        self.senderId = senderId
        self.senderName = senderName
        self.sentDate = sentDate.dateValue()
        self.id = document.documentID
        self.content = content
    }
}
