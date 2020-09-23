//
//  ChatRoomModel.swift
//  QiscusChat
//
//  Created by Willa on 23/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import Foundation



struct ChatRoomModel {
    
    var uniqueID: String
    var id: String
    var avatar: URL?
    var commentBeforeID: String?
    var date: Date?
    var displayDate: String?
    var name: String
    var type: ChatRoomType
    
    
}


enum ChatRoomType: String{
    case channel = "channel"
    case group = "group"
    case single = "single"
    
}




