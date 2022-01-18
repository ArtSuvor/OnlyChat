//
//  AuthError.swift
//  OnlyChat
//
//  Created by Art on 18.01.2022.
//

import Foundation

enum AuthError {
    case notField
    case invalidEmail
    case passNotMatched
    case unknownError
    case serverError
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notField:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Формат почты неправильный", comment: "")
        case .passNotMatched:
            return NSLocalizedString("Пароли не совпадают", comment: "")
        case .unknownError:
            return NSLocalizedString("Неизвестная ошибка", comment: "")
        case .serverError:
            return NSLocalizedString("Оштбка сервера", comment: "")
        }
    }
}
