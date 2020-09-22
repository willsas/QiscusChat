//
//  NetworkService.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}


struct Resource<T: Codable>{
    var url: URL
    var httpMethod: HTTPMethod
    var params: [String: String]?
    var headers: [String: String]?
}


/// Comform to this protocol if you want to make a new networking object
protocol NetworkingService {
    
    /// Perform a networking service
    /// - Parameters:
    ///   - resource: **Use BaseModel as a base generic resource : BaseModel<Resouce<T>>**
    ///   - completion: Generic type of resource
    func perform<T>(resource: Resource<T>, completion: @escaping (Swift.Result<T, NetworkingError>) -> Void)
}





enum NetworkingError: Error{
    case decodingError(Error?)
    case noNetwork(Error?)
    case noDataReceived(Error?)
    case other(String)
    case err(Error?)
}

extension NetworkingError: LocalizedError{
    
    public var errorDescription: String? {
        switch self {
            
        case .decodingError(let err):
            return NSLocalizedString("Error: Failed to get data", comment: "\(err?.localizedDescription ?? "")")
            
        case .noNetwork(let err):
            return NSLocalizedString("Error: No Network", comment: "\(err?.localizedDescription ?? "")")
            
        case .noDataReceived(let err):
            return NSLocalizedString("Error: No Data Received", comment: "\(err?.localizedDescription ?? "")")
            
        case .other(let msg):
            return NSLocalizedString("\(msg)", comment: "")
            
        case .err(let err):
            return NSLocalizedString("\(err?.localizedDescription ?? "Failed to get data")", comment: "")
            
        }
    }
}
