//
//  ChatService.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import Foundation

protocol ChatService {
    
    /// perform send a mesage
    /// - Parameter message: string message
    func sendChat(message: String)
}
