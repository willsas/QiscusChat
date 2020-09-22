//
//  UIWindow+Extension.swift
//  QiscusChat
//
//  Created by Willa on 23/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import UIKit

extension UIWindow{
    
    /// Swifch rootViewController  of a window  to the given view controleler,
    ///
    /// - Parameters:
    ///   - viewController: Given view controller
    ///   - animated: is animated, default is true
    ///   - duration: the animation duration, default is 0.5
    ///   - options: animation options, default is .curveEaseIn
    ///   - completion: called when finised animate
    func switchRootViewController(_ viewController: UIViewController,  animated: Bool = true, duration: TimeInterval = 0.5, options: UIView.AnimationOptions = .curveEaseIn, completion: (() -> Void)? = nil) {
        guard animated else {
            rootViewController = viewController
            return
        }
        
        UIView.transition(with: self, duration: duration, options: options, animations: { [unowned self] in
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }) { _ in
            completion?()
        }
    }
        
        
}
