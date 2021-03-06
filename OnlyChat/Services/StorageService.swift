//
//  StorageService.swift
//  OnlyChat
//
//  Created by Art on 26.01.2022.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class StorageService {
    static let shared = StorageService()
    private init() {}
    private let storageRef = Storage.storage().reference()
    private var avatarsRef: StorageReference {
        storageRef.child("avatars")
    }
    private var currentUserId: String {
        Auth.auth().currentUser!.uid
    }
    private var chatsRef: StorageReference {
        storageRef.child("chats")
    }
    
//MARK: - UploadProfilePhoto
    func uploadPhoto(photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let scaledImage = photo.scaledToSafeUploadSize,
              let imageData = scaledImage.jpegData(compressionQuality: 0.4) else { return }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        avatarsRef.child(currentUserId).putData(imageData, metadata: metadata) {[weak self] data, error in
            guard let self = self else { return }
            guard let _ = data else {
                completion(.failure(error!))
                return
            }
            self.avatarsRef.child(self.currentUserId).downloadURL { url, error in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            }
        }
    }
    
//MARK: - UploadMessagePhoto
    func uploadImageMessage(photo: UIImage, to chat: ChatModel, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let scaledImage = photo.scaledToSafeUploadSize,
              let imageData = scaledImage.jpegData(compressionQuality: 0.4) else { return }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let chatName = [chat.friendUserName, Auth.auth().currentUser!.uid].joined()
        
        chatsRef.child(chatName).child(imageName).putData(imageData, metadata: metadata) {[weak self] data, error in
            guard let self = self else { return }
            guard let _ = data else {
                completion(.failure(error!))
                return
            }
            self.chatsRef.child(chatName).child(imageName).downloadURL { url, error in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            }
        }
    }
    
//MARK: - DownloadImage
    func downloadImage(url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte: Int64 = 1 * 1024 * 1024
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(.failure(error!))
                return
            }
            completion(.success(UIImage(data: imageData)))
        }
    }
}
