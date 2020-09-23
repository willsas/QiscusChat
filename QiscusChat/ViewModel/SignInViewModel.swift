//
//  SignInViewModel.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import Foundation

protocol SignInViewModelDelegate: class {
    
    /// Get errors from all networking call
    /// - Parameter error: error
    func onError(error: Error)
    
    /// Succes sign in after calling requestToSignIn()
    func onSuccesSignIn()
}



class SignInViewModel {
    
    typealias Factory = SessionServiceFactory
    private var factory: Factory
  
    weak var delegate: SignInViewModelDelegate?
    
    var userId: String = ""
    var userKey: String = ""
    var username: String = ""
    
    
    init(factory: Factory) {
        self.factory = factory
    }
    
    
    
    /// Request to sign in with user id, user key, username from SignInViewModel local properties
    func requestToSignIn(){
        factory.requestToLogin(userID: userId, userKey: userKey, username: username) { [weak self] (response) in
            DispatchQueue.main.async { [weak self] in
                switch response{
                case .success(_):
                    self?.delegate?.onSuccesSignIn()
                case .failure(let err):
                    self?.delegate?.onError(error: err)
                }
            }
        }
    }
    
    
    
}
