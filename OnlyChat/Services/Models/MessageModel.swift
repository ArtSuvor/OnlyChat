//
//  MessageModel.swift
//  OnlyChat
//
//  Created by Art on 28.01.2022.
//

import UIKit
import FirebaseFirestore
import MessageKit

struct MessageModel: Hashable, MessageType {
    struct Sender: SenderType {
        var senderId: String
        var displayName: String
    }
    
//MARK: - Properties
    var sender: SenderType
    let content: String
    var sentDate: Date
    let id: String?
    var messageId: String {
        id ?? UUID().uuidString
    }
    var kind: MessageKind {
        .text(content)
    }
    var representation: [String: Any] {
        let rep: [String: Any] = [
            "created": sentDate,
            "senderId": sender.senderId,
            "senderName": sender.displayName,
            "content": content]
        return rep
    }
    
//MARK: - Init
    init(user: ModelUser, content: String) {
        self.sender = user
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
        
        self.sender = Sender(senderId: senderId, displayName: senderName)
        self.sentDate = sentDate.dateValue()
        self.id = document.documentID
        self.content = content
    }
    
//MARK: - Methods
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    static func == (lhs: MessageModel, rhs: MessageModel) -> Bool {
        lhs.messageId == rhs.messageId
    }
}
