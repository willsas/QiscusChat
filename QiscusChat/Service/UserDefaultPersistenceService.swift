//
//  UserDefaultPersistenceService.swift
//  QiscusChat
//
//  Created by Willa on 23/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import Foundation

struct UserDefaultPersistenceService: Persistable {
    
    let userDefault = UserDefaults.standard
    
    func saveData<T>(_ value: T?, forKey defaultName: PersistenceServiceKey) where T : Decodable, T : Encodable {
        let data = try? JSONEncoder().encode(value)
        userDefault.set(data, forKey: defaultName.rawValue)
    }

    func retriveData<T>(_ type: T.Type, forKey defaultName: PersistenceServiceKey) -> T? where T : Decodable {
        guard let encodedData = userDefault.data(forKey: defaultName.rawValue) else {
            return nil
        }
        return try? JSONDecoder().decode(type, from: encodedData)
    }
    
    
    func delete(key: PersistenceServiceKey) {
        userDefault.removeObject(forKey: key.rawValue)
    }
    
    
}
