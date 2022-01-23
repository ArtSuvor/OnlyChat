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
    case cannotGetUserInfo
    case cannotUnwrapToModel
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notField:
            return NSLocalizedString("Заполните все поля!", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Пользователь не выбрал фотографию.", comment: "")
        case .cannotGetUserInfo:
            return NSLocalizedString("Невозможно загрузить информациб о пользователе из Firebase", comment: "")
        case .cannotUnwrapToModel:
            return NSLocalizedString("Невозможно конвертировать User -> ModelUser", comment: "")
        }
    }
}
