//
//  RoomChatService.swift
//  QiscusChat
//
//  Created by Willa on 24/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import Foundation
import QiscusCore


class QiscusRoomListService: RoomListService {
    
    weak var delegate: RoomListDelegate?
    
    
    init() {
        QiscusCore.delegate = self
    }
    
    /// Request all chat rooms from local qiscuss storage
    private func requestRoomsFromLocal(){
        let result = QiscusCore.database.room.all()
        let mapping = result.map {self.maping($0)}
        delegate?.onGetNewRooms(rooms: (result, mapping))
    }
    
    
    /// Request all chat rooms from qiscus server
    private func requestRoomsFromServer(){
        
        QiscusCore.shared.getAllChatRooms(showParticipant: true, showRemoved: false, showEmpty: true, page: 1, limit: 50, onSuccess: { [weak self] (results, meta) in
            
            // send new room in delegate
            guard let self = self else {return}
            self.delegate?.onGetNewRooms(rooms: (results, results.map {self.maping($0)}))
            
            }, onError: { [weak self] (err) in
                
                // send error in delegate
                guard let self = self else {return}
                self.delegate?.onError(err: NetworkingError.other(err.message))
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
    
    
    
    // MARK: - protocol implementation
    
    func requestGetRooms() {
        requestRoomsFromLocal()
        requestRoomsFromServer()
    }
}






extension QiscusRoomListService: QiscusCoreDelegate{
    
    func onRoomMessageReceived(_ room: RoomModel, message: CommentModel) {
        
        // should show notif
        // i dont know why but it kinda delay sometimes to notify new room / msg
        requestGetRooms()
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
    
    func onRoomMessageDelivered(message: CommentModel) {}
    
    func onRoomMessageRead(message: CommentModel) { }
    
    
    // deprecated
    func onRoomDidChangeComment(comment: CommentModel, changeStatus status: CommentStatus) { }
    
 
}
