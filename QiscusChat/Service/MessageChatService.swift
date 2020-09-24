//
//  ChatManager.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import Foundation
import QiscusCore


class QiscusChatService: ChatService {
 
    
    weak var delegate: ChatDelegate?
    
  
    init(room: RoomModel) {
        room.delegate = self
    }
    
  
    private func makeTextTypeCommentModel(text: String, roomID: String) -> CommentModel{
        let model = CommentModel()
        model.message = text
        model.type = "text"
        model.roomId = roomID
//        model.extras = [clientIDKey: UUID.chatMessageUUID]
        return model
    }
    
    
    private func makeChatModel(commentModel comment: CommentModel) -> ChatModel{
        var status: ChatModelStatus = .pending
        switch comment.status {
        case .sent:
            status = .sent
        case .delivered:
            status = .delivered
        case .read:
            status = .read
        case .deleted:
            status = .deleted
        default:
            break
        }
        
        print("STATUS MESSAGE: \(comment.status)")
        

        return ChatModel(uniqueID: comment.uniqId,
                         roomID: comment.roomId,
                         message: comment.message,
                         status: status,
                         lastCommentID: comment.id,
                         date: comment.date)
        
    }
    
    
    
    
    
    // MARK: - Protocol function implementation
    
    func requestSendChat(message: String, withRoomID roomID: String) {
        let chat = makeTextTypeCommentModel(text: message, roomID: roomID)
        print(chat)
        
        QiscusCore.shared.sendMessage(message: makeTextTypeCommentModel(text: message, roomID: roomID), onSuccess: { [weak self] (commentModel) in
            guard let self = self else {return}
    
            self.delegate?.onGetNewChat(chat: self.makeChatModel(commentModel: commentModel))
            
        }) { [weak self] (err) in
            self?.delegate?.onError(err: NetworkingError.other(err.message))
        }
        
    }
    
    func getPreviousChat(withRoomID roomID: String, withLimit limit: Int) {
        
        QiscusCore.shared.getPreviousMessagesById(roomID: roomID, limit: limit, onSuccess: { [weak self] (commentsModel) in
            guard let self = self else {return}
            
            _ = commentsModel.map {self.makeChatModel(commentModel: $0)}.forEach { (chat) in
                self.delegate?.onGetNewChat(chat: chat)
            }
            
            
        }) { [weak self] (err) in
            
            self?.delegate?.onError(err: NetworkingError.other(err.message))
        }
    }
    
    func onReadMessageWithCommentID(commentID: String, roomID: String) {
        QiscusCore.shared.markAsRead(roomId: roomID, commentId: commentID)
    }
    
    
}



extension QiscusChatService: QiscusCoreRoomDelegate{
    
    func onMessageReceived(message: CommentModel) {
         self.delegate?.onGetNewChat(chat: self.makeChatModel(commentModel: message))
    }
    
    func didComment(comment: CommentModel, changeStatus status: CommentStatus) {
        self.delegate?.onGetNewChat(chat: self.makeChatModel(commentModel: comment))
    }
    
    func onMessageDelivered(message: CommentModel) {
         self.delegate?.onGetNewChat(chat: self.makeChatModel(commentModel: message))
    }
    
    func onMessageRead(message: CommentModel) {
        self.delegate?.onGetNewChat(chat: self.makeChatModel(commentModel: message))
    }
    
    func onMessageDeleted(message: CommentModel) {
//        self.delegate?.onGetNewChat(chat: self.makeChatModel(commentModel: message)
    }
    
    func onUserTyping(userId: String, roomId: String, typing: Bool) { }
    
    func onUserOnlinePresence(userId: String, isOnline: Bool, lastSeen: Date) { }
    
    func onRoom(update room: RoomModel) { }
    
    
}



