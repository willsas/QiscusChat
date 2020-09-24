//
//  URLSessionNetworkingService.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import Foundation

struct URLSessionNetworkingService: NetworkingService {
    
    func perform<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkingError>) -> Void) where T : Decodable, T : Encodable {
        
        // perform networking here
        
    }
    
    
}
