//
//  ListenerService.swift
//  OnlyChat
//
//  Created by Art on 27.01.2022.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ListenerService {
    static let shared = ListenerService()
    private init() {}
    
    private let db = Firestore.firestore()
    private var userRef: CollectionReference {
        db.collection("users")
    }
    private var currentUserId: String {
        Auth.auth().currentUser!.uid
    }
    
//MARK: - UserObserv
    func usersObserve(users: [ModelUser], completion: @escaping (Result<[ModelUser], Error>) -> Void) -> ListenerRegistration? {
        var users = users
        let userListener = userRef.addSnapshotListener {[weak self] snap, error in
            guard let snap = snap else {
                completion(.failure(error!))
                return
            }
            
            snap.documentChanges.forEach { diff in
                guard let user = ModelUser(diff.document) else { return }
                switch diff.type {
                case.added:
                    guard !users.contains(user),
                          user.senderId != self?.currentUserId else { return }
                    users.append(user)
                case .modified:
                    guard let index = users.firstIndex(of: user) else { return }
                    users[index] = user
                case .removed:
                    guard let index = users.firstIndex(of: user) else { return }
                    users.remove(at: index)
                }
            }
            completion(.success(users))
        }
        return userListener
    }
    
//MARK: - WaitingChatObserv
    func waitingChatsObserve(chats: [ChatModel], completion: @escaping (Result<[ChatModel], Error>) -> Void) -> ListenerRegistration? {
        var chats = chats
        let chatsRef = db.collection(["users", currentUserId, "waitingChats"].joined(separator: "/"))
        let chatsListener = chatsRef.addSnapshotListener { snap, error in
            guard let snap = snap else {
                completion(.failure(error!))
                return
            }
            snap.documentChanges.forEach { change in
                guard let chat = ChatModel(document: change.document) else { return }
                switch change.type {
                case .added:
                    guard !chats.contains(chat) else { return }
                    chats.append(chat)
                case .modified:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats[index] = chat
                case .removed:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats.remove(at: index)
                }
            }
            completion(.success(chats))
        }
        return chatsListener
    }
    
//MARK: - ActiveChatObserv
    func activeChatsObserve(chats: [ChatModel], completion: @escaping (Result<[ChatModel], Error>) -> Void) -> ListenerRegistration? {
        var chats = chats
        let chatsRef = db.collection(["users", currentUserId, "activeChats"].joined(separator: "/"))
        let chatsListener = chatsRef.addSnapshotListener { snap, error in
            guard let snap = snap else {
                completion(.failure(error!))
                return
            }
            snap.documentChanges.forEach { change in
                guard let chat = ChatModel(document: change.document) else { return }
                switch change.type {
                case .added:
                    guard !chats.contains(chat) else { return }
                    chats.append(chat)
                case .modified:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats[index] = chat
                case .removed:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats.remove(at: index)
                }
            }
            completion(.success(chats))
        }
        return chatsListener
    }
    
//MARK: - MessageObserver
    func messagesObserver(chat: ChatModel, completion: @escaping (Result<MessageModel, Error>) -> Void) -> ListenerRegistration? {
        let ref = userRef.document(currentUserId).collection("activeChats").document(chat.friendId).collection("messages")
        let messagesListener = ref.addSnapshotListener { snap, error in
            guard let snap = snap else {
                completion(.failure(error!))
                return
            }
            snap.documentChanges.forEach { change in
                guard let message = MessageModel(document: change.document) else { return }
                switch change.type {
                case .added:
                    completion(.success(message))
                case .modified:
                    break
                case .removed:
                    break
                }
            }
        }
        return messagesListener
    }
}
