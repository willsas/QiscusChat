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
    func makeChatRoomViewController() -> ChatRoomViewController
}

protocol SessionServiceFactory {
    
    /// Request user to login
    /// - Parameters:
    ///   - username: username
    ///   - completion: String Result type
    func requestToLogin(username: String, completion: (Result<String, Error>) -> Void)
}

protocol ChatServiceFactory {
    
    /// Make Chat Service Object
    func makeChatService() -> ChatService
}

protocol RemoteNotificationFactory {
    
    /// Request device notification permission
    func requestDevicePermission()
}

protocol CoordinatorFactory {
    
    /// Make Sign in Coordinator for SignInvViewController
    /// - Parameter vc: singinViewcontroller
    func makeSignInCoordinator(vc: UIViewController)  -> SignInCoordinator
    
    /// Make Chat List coordinator for Chat list coordinator
    /// - Parameter vc: ChatListCoordinator
    func makeChatListCoordinator(vc: UIViewController) -> ChatListCoordinator
}
