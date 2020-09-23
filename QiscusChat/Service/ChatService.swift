//
//  ChatService.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import Foundation


protocol RoomListDelegate: class {
    
    /// Get error from chat service
    /// - Parameter err: err with lcoalize desc
    func onError(err: Error)
    
    /// Get new chat rooom
    /// - Parameter rooms: array of ChatRoomModel
    func onGetNewRooms(rooms: [ChatRoomModel])
    
}

protocol ChatDelegate: class {
    
    /// Get error from chat service
    /// - Parameter err: err with lcoalize desc
    func onError(err: Error)
    
    /// Get new
    
    /// Get new chat
    /// - Parameter chat: ChatModel
    func onGetNewChat(chat: ChatModel)
    
}


protocol ChatService {
    
    /// perform send a mesage
    /// - Parameter message: string message
    func requestSendChat(message: String, withRoomID: String)
    
    /// request new rooms
    func requestGetRooms()
    
    
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
    
    
    /// room list delegate
    var roomListDelegate: RoomListDelegate?  {get set}
    
    /// chat list delegate
    var chatDelegate: ChatDelegate?  {get set}
    
    
    var onNewRooms: ([ChatRoomModel]) -> Void {get set}
    var onNewChat: (ChatModel) -> Void {get set}
    
}

