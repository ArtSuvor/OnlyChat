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
            "sender": sender,
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
              let sender = data["sender"] as? SenderType,
              let content = data["content"] as? String else { return nil }
        
        self.sender = sender
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
