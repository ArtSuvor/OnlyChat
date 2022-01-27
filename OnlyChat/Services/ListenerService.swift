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
                          user.id != self?.currentUserId else { return }
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
}
