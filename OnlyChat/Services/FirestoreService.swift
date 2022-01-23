//
//  FirestoreService.swift
//  OnlyChat
//
//  Created by Art on 21.01.2022.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseService {
    static let shared = FirebaseService()
    private let db = Firestore.firestore()
    private var usersRef: CollectionReference {
        db.collection("users")
    }
    
    func getUserData(user: User, completion: @escaping (Result<ModelUser, Error>) -> Void) {
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { snap, error in
            if let snap = snap, snap.exists {
                guard let muser = ModelUser(document: snap) else {
                    completion(.failure(UserError.cannotUnwrapToModel))
                    return
                }
                completion(.success(muser))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
    
    func saveProfileWith(id: String, email: String, userName: String?, avatarStringURL: String?, description: String?, sex: String?, completion: @escaping (Result<ModelUser, Error>) -> Void) {
        guard Validators.notEmpry(userName: userName, description: description, sex: sex) else {
            completion(.failure(UserError.notField))
            return
        }
        
        let model = ModelUser(id: id, name: userName!, email: email, description: description!, sex: sex!, avatarStringUrl: "")
        self.usersRef.document(model.id).setData(model.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(model))
            }
        }
    }
}
