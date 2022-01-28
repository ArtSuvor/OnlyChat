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
        
        StorageService.shared.uploadPhoto(photo: avatarImage!) { result in
            switch result {
            case .success(let url):
                model.avatarStringURL = url.absoluteString
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        usersRef.document(model.id).setData(model.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(model))
            }
        }
    }
    
    func createWaitingChat(message: String, receiver: ModelUser, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = db.collection(["users", receiver.id, "waitingChats"].joined(separator: "/"))
        let messageRef = reference.document(self.currentUser.id).collection("messages")
        
        let message = MessageModel(user: currentUser, content: message)
        let chat = ChatModel(friendUserName: currentUser.userName,
                             friendAvatarString: currentUser.avatarStringURL,
                             lastMessage: message.content,
                             friendId: currentUser.id)
        reference.document(currentUser.id).setData(chat.representation) { error in
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
}
