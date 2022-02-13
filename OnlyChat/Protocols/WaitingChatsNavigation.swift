//
//  WaitingChatsNavigation.swift
//  OnlyChat
//
//  Created by Art on 13.02.2022.
//

import Foundation

protocol WaitingChatsNavigation: AnyObject {
    func removeWaitingChat(chat: ChatModel)
    func changeToActive(chat: ChatModel)
}
