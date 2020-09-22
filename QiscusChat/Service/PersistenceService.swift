//
//  PersistenceService.swift
//  QiscusChat
//
//  Created by Willa on 23/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import Foundation

enum loginSessionType{
    case login
    case logout
}

/// Key for an object that conform Persistable Protocol
enum PersistenceServiceKey: String{
    
   case deviceToken
    
}



/// Object that dealing with local persistence should conform to this protocol and should make a dependecies maker in PersistableFactory
protocol Persistable {
    
    /// Saving data
    /// - Parameters:
    ///   - value: the value want to save, **the type of the value  should match the choosen "forKey" parameter (see  each key descriptions)**
    ///   - defaultName: enum PersistenceServiceKey
    func saveData<T: Codable>(_ value: T?, forKey defaultName: PersistenceServiceKey)
    
    
    /// Return data generic
    /// - Parameters:
    ///   - type: the object type you want to retrive, **the object type  should match the choosen "forKey" parameter (see  each key descriptions)**
    ///   - defaultName: enum PersistenceServiceKey
    /// - Returns: a value from the given key, it's   generic type from `type` params
    func retriveData<T>(_ type: T.Type, forKey defaultName: PersistenceServiceKey) -> T? where T : Decodable
    
    
    /// Deleting from the saved value
    /// - Parameter key: enum PersistenceServiceKey
    func delete(key: PersistenceServiceKey)
    
}


