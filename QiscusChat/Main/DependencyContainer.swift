//
//  DependencyContainer.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import UIKit

/**
##Dependency Container
implementation of FactoryProtocol funcitonality. All of each view controller functionality, being set in here, dependency container act as a mediator or a container

- DESCRIPTION: implement all the FactoryProtocol's protocol  here, and make as a global proerties in app delegate
*/



class DependecyContainer{
    
    private let networkService: NetworkingService
    
    init(networkService: NetworkingService) {
        self.networkService = networkService
    }
    
}


extension DependecyContainer: SessionServiceFactory{
    func requestToLogin(username: String, completion: (Result<String, Error>) -> Void) {
        // do login logic here
    }
    
}

extension DependecyContainer: ChatServiceFactory{
    func makeChatService() -> ChatService {
        return ChatManager()
    }
}


extension DependecyContainer: RemoteNotificationFactory{
    
    func requestDevicePermission() {
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = UIApplication.shared.delegate as! AppDelegate
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        
        
    }
    
    
}




extension DependecyContainer: CoordinatorFactory{
    func makeSignInCoordinator(vc: UIViewController) -> SignInCoordinator {
        return SignInCoordinator(vc: vc, factory: self)
    }
    
    func makeChatListCoordinator(vc: UIViewController) -> ChatListCoordinator {
        return ChatListCoordinator(vc: vc, factory: self)
    }
    
    
}



extension DependecyContainer: ViewControllerFactory{
    func makeSignInViewController() -> SignInViewController {
        return SignInViewController(factory: self)
    }
    
    func makeChatListViewController() -> ChatListViewController {
        return ChatListViewController(factory: self)
    }
    
    func makeChatRoomViewController() -> ChatRoomViewController {
        return ChatRoomViewController(factory: self)
    }
    
    
}


