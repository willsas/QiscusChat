//
//  ChatRoomViewModel.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import UIKit
import QiscusCore

protocol ChatRoomViewModelDelegate: class {
    
    /// OnNeedReload Table
    func onReloadData()
    
    /// get any error
    /// - Parameter err: error type
    func onError(err: Error)
    
    /// Succes send chat done append to chats array
    func onSuccesSendChat()
}

class ChatRoomViewModel: NSObject {
    
    typealias Factory = ChatServiceFactory
    private var factory: Factory
    private var room: RoomModel
    
    private var chats = [ChatModel]()
    
    private lazy var chatService: ChatService = {
        return factory.makeChatService(room: room)
    }()
    
    
    weak var delegate: ChatRoomViewModelDelegate?
    
    var typeChat: String = ""
    
    init(factory: Factory, room: RoomModel) {
        self.factory = factory
        self.room = room
        super.init()
        chatService.delegate = self
    }
    
    
    // MARK: - Private funcitons
    
    /// Handle coming new chat, new or status chages or any other new chat, and sorting it from oldes to newest to modified chats array
    /// - Parameter chat: ChatModel
    private func handleNewChat(_ chat: ChatModel){
        
        //determine if chat not available then append
        if !chats.contains(where: {$0.uniqueID == chat.uniqueID}){
            chats.append(chat)
        }else{
            if let index = chats.firstIndex(where: {$0.uniqueID == chat.uniqueID}),
                chats[safe: index] != nil{
                chats[index] = chat
            }
        }
        
        // sorting by date
        chats.sort { (first, second) -> Bool in
            first.date < second.date
        }
        
        delegate?.onReloadData()
        markAsRead()
        
    }
    
    
    /// mark as red when new message coming
    private func markAsRead(){
        guard let lastCommentID = chats.last?.lastCommentID else {return}
        chatService.onReadMessageWithCommentID(commentID: lastCommentID, roomID: room.id)
    }
    
    
    // MARK: - ViewController funcitons
    
    
    /// Request send message with text in  local properties typeChat from controller textfield binding
    func requestSendMessage(){
        chatService.requestSendChat(message: typeChat, withRoomID: room.id)
        delegate?.onSuccesSendChat()
    }
    
    
    /// Get new last message with limit 20, and fired the delegate
    func requestLastMessages(){
        chatService.getPreviousChat(withRoomID: room.id, withLimit: 20)
    }

  
}

// MARK: ChatDelegate
extension ChatRoomViewModel: ChatDelegate{
    func onGetNewChat(chat: ChatModel) {
        handleNewChat(chat)
    }
    
    func onError(err: Error) {
        delegate?.onError(err: err)
    }
}


// MARK: UITableViewDataSource
extension ChatRoomViewModel: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(ChatTableViewCell.self),
            let chat = chats[safe: indexPath.row]{
            cell.item = chat
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}
