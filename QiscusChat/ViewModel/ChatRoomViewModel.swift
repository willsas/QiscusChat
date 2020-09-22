//
//  ChatRoomViewModel.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import Foundation

class ChatRoomViewModel {
    
    typealias Factory = ChatServiceFactory
    
    private var factory: Factory
    
    private lazy var chatService: ChatService = {
        return factory.makeChatService()
    }()
    
    init(factory: Factory) {
        self.factory = factory
    }
    
}
