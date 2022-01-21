//
//  UserError.swift
//  OnlyChat
//
//  Created by Art on 21.01.2022.
//

import Foundation

enum UserError {
    case notField
    case photoNotExist
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notField:
            return NSLocalizedString("Заполните все поля!", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Пользователь не выбрал фотографию.", comment: "")
        }
    }
}
