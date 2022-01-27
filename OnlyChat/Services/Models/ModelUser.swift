//
//  ModelUser.swift
//  OnlyChat
//
//  Created by Art on 17.01.2022.
//

import Foundation
import FirebaseFirestore

struct ModelUser: Hashable, Decodable {
    
//MARK: - Properties
    let id: String
    let userName: String
    var avatarStringURL: String
    let email: String
    let description: String
    let sex: String
    
    var representation: [String: Any] {
        var rep = ["uid": id]
        rep["userName"] = userName
        rep["email"] = email
        rep["avatarStringUrl"] = avatarStringURL
        rep["description"] = description
        rep["sex"] = sex
        return rep
    }
    
//MARK: - Init
    init(id: String, name: String, email: String, description: String, sex: String, avatarStringUrl: String) {
        self.id = id
        self.userName = name
        self.email = email
        self.description = description
        self.sex = sex
        self.avatarStringURL = avatarStringUrl
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        guard let userName = data["userName"] as? String,
              let id = data["uid"] as? String,
              let imageUrl = data["avatarStringUrl"] as? String,
              let email = data["email"] as? String,
              let description = data["description"] as? String,
              let sex = data["sex"] as? String else { return nil }
        self.id = id
        self.userName = userName
        self.avatarStringURL = imageUrl
        self.email = email
        self.description = description
        self.sex = sex
    }
    
    init?(_ document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let userName = data["userName"] as? String,
              let id = data["uid"] as? String,
              let imageUrl = data["avatarStringUrl"] as? String,
              let email = data["email"] as? String,
              let description = data["description"] as? String,
              let sex = data["sex"] as? String else { return nil }
        self.id = id
        self.userName = userName
        self.avatarStringURL = imageUrl
        self.email = email
        self.description = description
        self.sex = sex
    }
    
//MARK: - Methods
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ModelUser, rhs: ModelUser) -> Bool {
        lhs.id == rhs.id
    }
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        let lower = filter.lowercased()
        return userName.lowercased().contains(lower)
    }
}
