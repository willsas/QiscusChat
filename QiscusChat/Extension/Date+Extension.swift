//
//  Date+Extension.swift
//  QiscusChat
//
//  Created by Willa on 23/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import Foundation

extension Date{
    
    /// Date format to string
    /// - Parameter format: format, the default is dd-MM-yyyy
    /// - Returns: string of Date
    func toString(format: String = "dd-MM-yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    
}
