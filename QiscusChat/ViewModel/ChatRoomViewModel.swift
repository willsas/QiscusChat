//
//  ChatRoomViewModel.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import UIKit

protocol ChatRoomViewModelDelegate: class {
    func onReloadData()
    func onError(err: Error)
    func onSuccesSendChat()
}

class ChatRoomViewModel: NSObject {
    
    typealias Factory = ChatServiceFactory
    private var factory: Factory
    private var roomID: String
    
    private var chats = [ChatModel]()
    
    private lazy var chatService: ChatService = {
        return factory.makeChatService()
    }()
    
    
    weak var delegate: ChatRoomViewModelDelegate?
    
    var typeChat: String = ""
    
    init(factory: Factory, roomID: String) {
        self.factory = factory
        self.roomID = roomID
        super.init()
        chatService.chatDelegate = self
    }
    
    
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
    
    private func markAsRead(){
        guard let lastCommentID = chats.last?.lastCommentID else {return}
        chatService.onReadMessageWithCommentID(commentID: lastCommentID, roomID: roomID)
    }
    
    
    
    func requestSendMessage(){
        chatService.requestSendChat(message: typeChat, withRoomID: roomID)
        delegate?.onSuccesSendChat()
    }
    
    func requestLastMessages(){
        chatService.getPreviousChat(withRoomID: roomID, withLimit: 20)
    }
    
    func setChatServiceDelegate(){
        chatService.chatDelegate = self
    }
  
}


extension ChatRoomViewModel: ChatDelegate{
    func onGetNewChat(chat: ChatModel) {
        handleNewChat(chat)
    }
    
    func onError(err: Error) {
        delegate?.onError(err: err)
    }
}


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
