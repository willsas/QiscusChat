//
//  FactoryProtocols.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import UIKit

/**
##FACTORY PROTOCOL
factory protocol is one of the approach of protocol oriented programming and dependecy injections.  in order to  make code tetstable and less decouple

- DESCRIPTION: All the functionality, network request, class dependecies, custom class dependencies, put it as a protocol here

- SOURCE:  [dependecy injection by swift by sundell]  https://www.swiftbysundell.com/articles/dependency-injection-using-factories-in-swift/
*/



protocol ViewControllerFactory{
    
    /// Return Sign in View Controller
    func makeSignInViewController() -> SignInViewController
    
    /// Return chat list view controller
    func makeChatListViewController() -> ChatListViewController
    
    /// Return chat room view controller
    func makeChatRoomViewController(chatRoom: ChatRoomModel) -> ChatRoomViewController
}

protocol SessionServiceFactory {
    
    /// Request user to login and SET Qiscuss connect delegate to app delegate if success
    /// - Parameters:
    ///   - userKey: username
    ///   - userID: userid
    ///   - username: user display name
    ///   - completion: Bool is succes Result type
    func requestToLogin(userID: String, userKey: String, username: String, completion: @escaping (Result<Bool, Error>) -> Void)
    
}

protocol ChatServiceFactory {
    
    /// Make Chat Service Object
    func makeChatService() -> ChatService
}

protocol RemoteNotificationFactory {
    
    /// Request device notification permission
    func requestDevicePermission()
    
    
    /// Register new token every new token came up
    /// - Parameters:
    ///   - withToken: String token
    ///   - completion: Result type of Bool, if registering is complete
    func requestToRegisterNewDeviceToken(withToken token: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

protocol PersistenceServiceFactory {
    
    /// Return Persistable object based on user default
    func makeUserDefault() -> Persistable
}

protocol CoordinatorFactory {
    
    /// Make Sign in Coordinator for SignInvViewController
    /// - Parameter vc: singinViewcontroller
    func makeSignInCoordinator(vc: UIViewController)  -> SignInCoordinator
    
    /// Make Chat List coordinator for Chat list coordinator
    /// - Parameter vc: ChatListCoordinator
    func makeChatListCoordinator(vc: UIViewController) -> ChatListCoordinator
}
