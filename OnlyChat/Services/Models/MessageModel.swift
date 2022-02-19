//
//  MessageModel.swift
//  OnlyChat
//
//  Created by Art on 28.01.2022.
//

import UIKit
import FirebaseFirestore
import MessageKit

struct ImageItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

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
    var image: UIImage? = nil
    var downloadURL: URL? = nil
    var messageId: String {
        id ?? UUID().uuidString
    }
    var kind: MessageKind {
        if let image = image {
            let mediaItem = ImageItem(url: nil, image: nil, placeholderImage: image, size: image.size)
            return .photo(mediaItem)
        } else {
            return .text(content)
        }
    }
    var representation: [String: Any] {
        var rep: [String: Any] = [
            "created": sentDate,
            "senderId": sender.senderId,
            "senderName": sender.displayName]
        
        if let url = downloadURL {
            rep["url"] = url.absoluteString
        } else {
            rep["content"] = content
        }
        
        return rep
    }
    
//MARK: - Init
    init(user: ModelUser, content: String) {
        self.sender = user
        self.sentDate = Date()
        self.id = nil
        self.content = content
    }
    
    init(user: ModelUser, image: UIImage) {
        self.sender = user
        self.sentDate = Date()
        self.id = nil
        self.image = image
        self.content = ""
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        guard let sentDate = data["created"] as? Timestamp,
              let senderId = data["senderId"] as? String,
              let senderName = data["senderName"] as? String else { return nil }
        
        self.sender = Sender(senderId: senderId, displayName: senderName)
        self.sentDate = sentDate.dateValue()
        self.id = document.documentID
        
        if let content = data["content"] as? String {
            self.content = content
            self.downloadURL = nil
        } else if let urlString = data["url"] as? String,
                  let url = URL(string: urlString) {
            self.downloadURL = url
            self.content = ""
        } else {
            return nil
        }
    }
    
//MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    static func == (lhs: MessageModel, rhs: MessageModel) -> Bool {
        lhs.messageId == rhs.messageId
    }
}

//MARK: - Comparable
extension MessageModel: Comparable {
    static func < (lhs: MessageModel, rhs: MessageModel) -> Bool {
        lhs.sentDate < rhs.sentDate
    }
}
