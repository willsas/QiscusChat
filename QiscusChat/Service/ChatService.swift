//
//  ChatService.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import Foundation
import QiscusCore


protocol ChatDelegate: class {
    
    /// Get error from chat service
    /// - Parameter err: err with lcoalize desc
    func onError(err: Error)
    
    /// Get new chat
    /// - Parameter chat: ChatModel
    func onGetNewChat(chat: ChatModel)
    
}


protocol ChatService {
    
    
    /// chat list delegate
    var delegate: ChatDelegate?  {get set}
    
    /// perform send a mesage
    /// - Parameter message: string message
    func requestSendChat(message: String, withRoomID: String)
    
    
    /// Get previous messages
    /// - Parameters:
    ///   - withRoomID: room id
    ///   - limit: limit chat
    func getPreviousChat(withRoomID: String, withLimit: Int)
    
    
    
    /// Mark as read with given last comment ID
    /// - Parameters:
    ///   - commentID: last comment id, in ChatModel.lastCommentID or CommentModel.id
    ///   - roomID: room id
    func onReadMessageWithCommentID(commentID: String, roomID: String)
    
  
}




protocol RoomListDelegate: class {
    
    /// Get error from chat service
    /// - Parameter err: err with lcoalize desc
    func onError(err: Error)
    
    /// Get new chat room after calling requstGetRoom()
    /// - Parameter rooms: a tuple of array RoomModel and ChatRoomModel
    func onGetNewRooms(rooms: ([RoomModel], [ChatRoomModel]))
    
}



protocol RoomListService {
    
    /// room list delegate
    var delegate: RoomListDelegate?  {get set}
    
    /// request new rooms
    func requestGetRooms()
}
