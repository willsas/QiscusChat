//
//  UIAlertController+Extension.swift
//  QiscusChat
//
//  Created by Willa on 23/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import UIKit

extension UIAlertController{
    
      /// Show Basic alert
      /// - Parameters:
      ///   - title: titile alert
      ///   - message: message alert
      ///   - vc: view controller to show alert
      static func basicAlert(title: String?, message: String?, vc: UIViewController){
          let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
          let action = UIAlertAction(title: "OK", style: .default, handler: nil)
          alert.addAction(action)
          vc.present(alert, animated: true)
      }
    
    
}


