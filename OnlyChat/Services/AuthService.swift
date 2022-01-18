//
//  AuthService.swift
//  OnlyChat
//
//  Created by Art on 18.01.2022.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthService {
    static let shared = AuthService()
    private let auth = Auth.auth()
    private init() {}
    
    func register(email: String?, password: String?, confirmPas: String?, completion: @escaping (Result<User, Error>) -> Void) {
        if Validators.isField(email: email, password: password, confirmPas: confirmPas) {
            if password!.lowercased() == confirmPas!.lowercased() {
                if email!.isValid(validType: .email) {
                    if password!.isValid(validType: .password) {
                        auth.createUser(withEmail: email!, password: password!) { result, error in
                            guard let result = result else {
                                completion(.failure(error!))
                                return
                            }
                            completion(.success(result.user))
                        }
                    } else {
                        completion(.failure(AuthError.unknownError))
                        return
                    }
                } else {
                    completion(.failure(AuthError.invalidEmail))
                    return
                }
            } else {
                completion(.failure(AuthError.passNotMatched))
                return
            }
        } else {
            completion(.failure(AuthError.notField))
            return
        }
    }
    
    func login(email: String?, password: String?, completion: @escaping (Result<User, Error>) -> Void) {
        guard let email = email,
              let password = password else {
                  completion(.failure(AuthError.notField))
                  return
              }
        auth.signIn(withEmail: email, password: password) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
}
