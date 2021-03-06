//
//  FirestoreService.swift
//  OnlyChat
//
//  Created by Art on 21.01.2022.
//

import Foundation
import Firebase
import FirebaseFirestore
import UIKit

class FirebaseService {
    static let shared = FirebaseService()
    private init() {}
    private let db = Firestore.firestore()
    private var usersRef: CollectionReference {
        db.collection("users")
    }
    private var currentUser: ModelUser!
    private var waitingChatRef: CollectionReference {
        db.collection(["users", currentUser.senderId, "waitingChats"].joined(separator: "/"))
    }
    private var activeChatRef: CollectionReference {
        db.collection(["users", currentUser.senderId, "activeChats"].joined(separator: "/"))
    }
    
//MARK: - GetUserData
    func getUserData(user: User, completion: @escaping (Result<ModelUser, Error>) -> Void) {
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { snap, error in
            if let snap = snap, snap.exists {
                guard let muser = ModelUser(document: snap) else {
                    completion(.failure(UserError.cannotUnwrapToModel))
                    return
                }
                self.currentUser = muser
                completion(.success(muser))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
    
//MARK: - SaveProfile
    func saveProfileWith(id: String, email: String, userName: String?, avatarImage: UIImage?, description: String?, sex: String?, completion: @escaping (Result<ModelUser, Error>) -> Void) {
        guard Validators.notEmpry(userName: userName, description: description, sex: sex) else {
            completion(.failure(UserError.notField))
            return
        }
        guard avatarImage != UIImage(named: "avatar") else {
            completion(.failure(UserError.photoNotExist))
            return
        }
        
        var model = ModelUser(id: id, name: userName!, email: email, description: description!, sex: sex!, avatarStringUrl: "")
        
        StorageService.shared.uploadPhoto(photo: avatarImage!) {[weak self] result in
            switch result {
            case let .success(url):
                model.avatarStringURL = url.absoluteString
                self?.usersRef.document(model.senderId).setData(model.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(model))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
//MARK: - CreateWaitingChat
    func createWaitingChat(message: String, receiver: ModelUser, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = db.collection(["users", receiver.senderId, "waitingChats"].joined(separator: "/"))
        let messageRef = reference.document(self.currentUser.senderId).collection("messages")
        
        let message = MessageModel(user: currentUser, content: message)
        let chat = ChatModel(friendUserName: currentUser.displayName,
                             friendAvatarString: currentUser.avatarStringURL,
                             lastMessage: message.content,
                             friendId: currentUser.senderId)
        reference.document(currentUser.senderId).setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            messageRef.addDocument(data: message.representation) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(Void()))
            }
        }
    }
    
//MARK: - RemoveWaitingChat
    func deleteWaitingChat(chat: ChatModel, completion: @escaping (Result<Void, Error>) -> Void) {
        waitingChatRef.document(chat.friendId).delete {[weak self] error in
            if let error = error {
                completion(.failure(error))
                return
            }
            self?.deleteMessages(chat: chat, completion: completion)
        }
    }
    
//MARK: - DeleteMessages
    func deleteMessages(chat: ChatModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let ref = waitingChatRef.document(chat.friendId).collection("messages")
        getWaitingChatMesseges(chat: chat) { result in
            switch result {
            case let .success(messages):
                messages.forEach { message in
                    guard let documentId = message.id else { return }
                    let messageRef = ref.document(documentId)
                    messageRef.delete { error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        completion(.success(Void()))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
//MARK: - GetMessages
    func getWaitingChatMesseges(chat: ChatModel, completion: @escaping (Result<[MessageModel], Error>) -> Void) {
        var messages = [MessageModel]()
        let ref = waitingChatRef.document(chat.friendId).collection("messages")
        ref.getDocuments { snap, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            snap?.documents.forEach { doc in
                guard let message = MessageModel(document: doc) else { return }
                messages.append(message)
            }
            completion(.success(messages))
        }
    }
    
//MARK: - ChangeToActive
    func changeToActive(chat: ChatModel, completion: @escaping (Result<Void, Error>) -> Void) {
        getWaitingChatMesseges(chat: chat) {[weak self] result in
            switch result {
            case let .success(messages):
                self?.deleteWaitingChat(chat: chat) { result in
                    switch result {
                    case .success:
                        self?.createActiveChat(chat: chat, messages: messages) { result in
                            switch result {
                            case .success:
                                completion(.success(Void()))
                            case let .failure(error):
                                completion(.failure(error))
                            }
                        }
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
//MARK: - CreateActiveChat
    func createActiveChat(chat: ChatModel, messages: [MessageModel], completion: @escaping (Result<Void, Error>) -> Void) {
        let messageRef = activeChatRef.document(chat.friendId).collection("messages")
        activeChatRef.document(chat.friendId).setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            messages.forEach { message in
                messageRef.addDocument(data: message.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
    
//MARK: - SendMessage
    func sendMessage(chat: ChatModel, message: MessageModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let friendRef = usersRef.document(chat.friendId).collection("activeChats").document(currentUser.senderId)
        let friendMessageRef = friendRef.collection("messages")
        let myMessageRef = usersRef.document(currentUser.senderId).collection("activeChats").document(chat.friendId).collection("messages")
        let chatForFriend = ChatModel(friendUserName: currentUser.displayName,
                                      friendAvatarString: currentUser.avatarStringURL,
                                      lastMessage: message.content,
                                      friendId: currentUser.senderId)
        
        friendRef.setData(chatForFriend.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            friendMessageRef.addDocument(data: message.representation) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                myMessageRef.addDocument(data: message.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
}
