//
//  UUID+Extension.swift
//  QiscusChat
//
//  Created by Willa on 24/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import Foundation

extension UUID{
    
    /// Get message unique id, with prefix "IOS-"
    /// - Returns: string of message unique id with prefix IOS-
    static func chatMessageUUID() -> String{
        return "IOS-" + UUID().uuidString
        
    }
}
