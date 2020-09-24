//
//  Coordinators.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import UIKit
import QiscusCore


protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    var vc: UIViewController? { get set }
    var factory: ViewControllerFactory { get set }
}

struct SignInCoordinator: Coordinator{
    
    typealias Factory = ViewControllerFactory
    
    var navigationController: UINavigationController?
    
    var vc: UIViewController?
    
    var factory: ViewControllerFactory
    
    init(vc: UIViewController, factory: ViewControllerFactory) {
        self.vc = vc
        self.navigationController = vc.navigationController
        self.factory = factory
    }
    
    
    /// Switch window to chat list view controller
    func switchToChatListViewController(){
        guard let window = UIApplication.shared.windows.first else {return}
        let nav = UINavigationController(rootViewController: factory.makeChatListViewController())
        nav.navigationBar.prefersLargeTitles = true
        window.switchRootViewController(nav)
        
    }
    
    
}

struct ChatListCoordinator: Coordinator {
    
    typealias Factory = ViewControllerFactory
    
    var navigationController: UINavigationController?
    
    var vc: UIViewController?
    
    var factory: ViewControllerFactory
    
    
    init(vc: UIViewController, factory: ViewControllerFactory) {
        self.vc = vc
        self.navigationController = vc.navigationController
        self.factory = factory
    }
    
    
    /// Push to chat room view controller
    /// - Parameter room: given tuple of RoomModel, and ChatRoomModel
    /// - note: Why would you put delegate on RoomModel, should I import QiscusCore to  all over the file?, thanks
    func pushToChatRoomViewController(withRoom room: (RoomModel, ChatRoomModel)){
        navigationController?.pushViewController(factory.makeChatRoomViewController(room: room), animated: true)
    }
    
}
