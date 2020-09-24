//
//  ChatListViewModel.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import UIKit
import QiscusCore

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
    private var roomsModel = [RoomModel]()
    
    
    private lazy var chatListService: RoomListService = {
        return factory.makeRoomListService()
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
    
    // MARK: - Private funcitons
    
    
    /// Setup ChatService
    private func setupChatService(){
        chatListService.delegate = self
    }
    
    
    
    // MARK: - ViewController funcitons
    
    /// Call requestGetRooms in ChatServie
    func requestChatRooms(){
        chatListService.requestGetRooms()
    }
    
    
    /// Get a RoomModel and ChatRoomModel with given  index
    /// - Parameter index: Table view index
    /// - Returns: tuple of RoomModel and ChatRoomModel
    func getRoomAt(_ index: Int) -> (RoomModel, ChatRoomModel)?{
        guard let room = rooms[safe: index],
            let roomModel = roomsModel[safe: index] else {return nil}
        return (roomModel, room)
    }
    
    
}



// MARK: RoomListDelegate
extension ChatListViewModel: RoomListDelegate{
    
    func onGetNewRooms(rooms: ([RoomModel], [ChatRoomModel])) {
        self.rooms = rooms.1
        self.roomsModel = rooms.0
    }
    
    func onError(err: Error) {
        delegate?.onError(err: err)
    }
    
}

// MARK: UITableViewDataSource
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
