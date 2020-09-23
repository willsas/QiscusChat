//
//  Array+Extension.swift
//  QiscusChat
//
//  Created by Willa on 23/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import Foundation

extension Array{
    
    /// Get value of array in safe mode / optional
    public subscript(safe index: Int) -> Element?{
        guard startIndex <= index && index < endIndex else {
            return nil
        }
        return self[index]
    }
    
}
