//
//  ChatModel.swift
//  QiscusChat
//
//  Created by Willa on 24/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import Foundation


struct ChatModel {
    var uniqueID: String
    var roomID: String
    var message: String
    var status: ChatModelStatus = .pending
    var lastCommentID: String
//    var clientID: String?
    var date: Date
}


enum ChatModelStatus: String {
    case pending = "PENDING"
    case sent = "SENT"
    case delivered = "DELIVERED"
    case read = "READ"
    case deleted = "DELETED"
}
