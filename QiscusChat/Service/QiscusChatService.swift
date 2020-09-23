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
 
    
    weak var roomListDelegate: RoomListDelegate?
    weak var chatDelegate: ChatDelegate?
    
    private var clientIDKey = "clientID"
    
    
    var onNewRooms: ([ChatRoomModel]) -> Void = {_ in}
    var onNewChat: (ChatModel) -> Void = {_ in}
    
  
    init() {
        QiscusCore.delegate = self
        
    }
    
    
    /// Request all chat rooms from local qiscuss storage
    private func requestRoomsFromLocal(){
        let result = QiscusCore.database.room.all().map {self.maping($0)}
        roomListDelegate?.onGetNewRooms(rooms: result)
        onNewRooms(result)
    }
    
    
    /// Request all chat rooms from qiscus server
    private func requestRoomsFromServer(){
        
        QiscusCore.shared.getAllChatRooms(showParticipant: true, showRemoved: false, showEmpty: true, page: 1, limit: 50, onSuccess: { [weak self] (results, meta) in
            
            // send new room in delegate
            guard let self = self else {return}
            self.roomListDelegate?.onGetNewRooms(rooms: results.map {self.maping($0)})
            self.onNewRooms(results.map {self.maping($0)})
            
        }, onError: { [weak self] (err) in
            
            // send error in delegate
            guard let self = self else {return}
            self.roomListDelegate?.onError(err: NetworkingError.other(err.message))
        })
        
    }
    
    
    
    /// Mapping raw RoomModel to convert it in ChatRoomModel
    /// - Parameter room: Raw RoomModel from qiscuss
    /// - Returns: ChatRoomModel
    private func maping(_ room: RoomModel) -> ChatRoomModel{
        
        var type: ChatRoomType = .channel
        switch room.type {
        case .channel:
            type = .channel
        case .group:
            type = .group
        case .single:
            type = .single
        }
        
        room.delegate = nil
    
        return ChatRoomModel(
            uniqueID: room.uniqueId,
            id: room.id,
            avatar: room.avatarUrl,
            commentBeforeID:
            room.lastComment?.message,
            date: room.lastComment?.date,
            displayDate: room.lastComment?.date.toString(format: "dd-MM HH:mm"),
            name: room.name,
            type: type)
    }
    
    
    private func makeTextTypeCommentModel(text: String, roomID: String) -> CommentModel{
        let model = CommentModel()
        model.message = text
        model.type = "text"
        model.roomId = roomID
//        model.extras = [clientIDKey: UUID.chatMessageUUID]
        return model
    }
    
    
    private func makeChatModel(commentModel comment: CommentModel, dateSent date: Date) -> ChatModel{
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
                         date: date)
        
    }
    
    
    
    
    
    // MARK: - Protocol function implementation
    
    func requestSendChat(message: String, withRoomID roomID: String) {
        let chat = makeTextTypeCommentModel(text: message, roomID: roomID)
        print(chat)
        
        QiscusCore.shared.sendMessage(message: makeTextTypeCommentModel(text: message, roomID: roomID), onSuccess: { [weak self] (commentModel) in
            guard let self = self else {return}
    
            self.chatDelegate?.onGetNewChat(chat: self.makeChatModel(commentModel: commentModel, dateSent: Date()))
            self.onNewChat(self.makeChatModel(commentModel: commentModel, dateSent: Date()))
            
        }) { [weak self] (err) in
            self?.chatDelegate?.onError(err: NetworkingError.other(err.message))
        }
        
    }
    
    func getPreviousChat(withRoomID roomID: String, withLimit limit: Int) {
        
        QiscusCore.shared.getPreviousMessagesById(roomID: roomID, limit: limit, onSuccess: { [weak self] (commentsModel) in
            guard let self = self else {return}
            
            _ = commentsModel.map {self.makeChatModel(commentModel: $0, dateSent: $0.date)}.forEach { (chat) in
                self.chatDelegate?.onGetNewChat(chat: chat)
                self.onNewChat(chat)
            }
            
            
        }) { [weak self] (err) in
            
            self?.chatDelegate?.onError(err: NetworkingError.other(err.message))
        }
    }
    
    func onReadMessageWithCommentID(commentID: String, roomID: String) {
        QiscusCore.shared.markAsRead(roomId: roomID, commentId: commentID)
    }
    
    func requestGetRooms() {
        requestRoomsFromLocal()
        requestRoomsFromServer()
    }
    
    
}



extension QiscusChatService: QiscusCoreDelegate{
    
    func onRoomMessageReceived(_ room: RoomModel, message: CommentModel) {
        
        // should show notif
        // i dont know why but it kinda delay sometimes to notify new room / msg
        requestGetRooms()
        chatDelegate?.onGetNewChat(chat: makeChatModel(commentModel: message, dateSent: message.date))
        onNewChat(makeChatModel(commentModel: message, dateSent: message.date))
    }
    
    func onRoom(update room: RoomModel) {
         requestGetRooms()
     }
     
     func onRoom(deleted room: RoomModel) {
         requestGetRooms()
     }
     
     func gotNew(room: RoomModel) {
         requestGetRooms()
     }
     
     func onChatRoomCleared(roomId: String) {
         requestGetRooms()
     }
    
    

    func onRoomMessageDeleted(room: RoomModel, message: CommentModel) { }
    
    func onRoomMessageDelivered(message: CommentModel) {
        chatDelegate?.onGetNewChat(chat: makeChatModel(commentModel: message, dateSent: message.date))
        onNewChat(makeChatModel(commentModel: message, dateSent: message.date))
    }
    
    func onRoomMessageRead(message: CommentModel) {
        chatDelegate?.onGetNewChat(chat: makeChatModel(commentModel: message, dateSent: message.date))
        onNewChat(makeChatModel(commentModel: message, dateSent: message.date))
    }
    
    
    // deprecated
    func onRoomDidChangeComment(comment: CommentModel, changeStatus status: CommentStatus) { }
    
 
}
