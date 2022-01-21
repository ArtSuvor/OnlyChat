//
//  Validators.swift
//  OnlyChat
//
//  Created by Art on 18.01.2022.
//

import Foundation

class Validators {
    static func isField(email: String?, password: String?, confirmPas: String?) -> Bool {
        guard let email = email,
              let password = password,
              let confirm = confirmPas,
              email != "",
              password != "",
              confirm != "" else {
                  return false
              }
        return true
    }
    
    static func notEmpry(userName: String?, description: String?, sex: String?) -> Bool {
        guard let user = userName,
              let des = description,
              let sex = sex,
              user != "",
              des != "",
              sex != "" else { return false }
        return true
    }
}
