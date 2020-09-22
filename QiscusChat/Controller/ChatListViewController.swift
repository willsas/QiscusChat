//
//  ChatListViewController.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController {
    
    
    typealias Factory =  CoordinatorFactory
    
    private let factory: Factory
    
    private lazy var coordinator: ChatListCoordinator = {
        return factory.makeChatListCoordinator(vc: self)
    }()
    
    init(factory: Factory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Chats"
        
        // Do any additional setup after loading the view.
    }




}
