//
//  ChatListViewModel.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import UIKit

protocol ChatListViewModelDelegate: class {
    
    /// Need to reload data, table data source is changed
    func onReloadData()
    
    /// Get error from all network call
    /// - Parameter err: error type
    func onError(err: Error)
}

class ChatListViewModel: NSObject {
    
    typealias Factory = ChatServiceFactory
    private var factory: Factory
    
    private lazy var chatService: ChatService = {
        return factory.makeChatService()
    }()
    
    private var rooms = [ChatRoomModel](){
          didSet{
              delegate?.onReloadData()
          }
      }
    
    
    weak var delegate: ChatListViewModelDelegate?
    
    
    init(factory: Factory) {
        self.factory = factory
        super.init()
        setupChatService()
        
    }
    
    
    /// Setup ChatService
    private func setupChatService(){
        chatService.delegate = self
    }
    
    
    /// Call requestGetRooms in ChatServie
    func requestChatRooms(){
        chatService.requestGetRooms()
    }
    
}



extension ChatListViewModel: ChatServiceDelegate{
    
    func onGetNewRooms(rooms: [ChatRoomModel]) {
        self.rooms = rooms
    }
    
    func onError(err: Error) {
        delegate?.onError(err: err)
    }
    
}


extension ChatListViewModel: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(RoomTableViewCell.self),
            let room = rooms[safe: indexPath.row]{
            cell.chatRoom = room
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}
