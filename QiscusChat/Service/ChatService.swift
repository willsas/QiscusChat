//
//  ChatService.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import Foundation

protocol ChatServiceDelegate: class {
    
    /// Get new chat rooom
    /// - Parameter rooms: array of ChatRoomModel
    func onGetNewRooms(rooms: [ChatRoomModel])
    
    /// Get new chat
    func onGetNewChat()
    
    /// Get error from chat service
    /// - Parameter err: err with lcoalize desc
    func onError(err: Error)
}

extension ChatServiceDelegate{
    func onGetNewRooms(rooms: [ChatRoomModel]) {}
    func onGetNewChat() {}
}

protocol ChatService {
    
    /// perform send a mesage
    /// - Parameter message: string message
    func requestSendChat(message: String)
    
    
    /// request new rooms
    func requestGetRooms()
    
   /// set the delegate
    var delegate: ChatServiceDelegate? {get set}
    
}
