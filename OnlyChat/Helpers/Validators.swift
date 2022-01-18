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
}
