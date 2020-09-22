//
//  ChatRoomViewController.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import UIKit

class ChatRoomViewController: UIViewController {
    
    typealias Factory =  ChatServiceFactory
      
      private let factory: Factory
      
     
      init(factory: Factory) {
          self.factory = factory
          super.init(nibName: nil, bundle: nil)
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
