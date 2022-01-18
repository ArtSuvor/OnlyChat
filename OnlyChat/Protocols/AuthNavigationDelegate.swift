//
//  AuthNavigationDelegate.swift
//  OnlyChat
//
//  Created by Art on 18.01.2022.
//

import Foundation

protocol AuthNavigationDelegate: AnyObject {
    func toLoginVC()
    func toSignUpVC()
}
