//
//  SignInViewModel.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import Foundation

protocol SignInViewModelDelegate: class {
    func onError(error: Error)
    func onSuccesSignIn()
}

class SignInViewModel {
    
    typealias Factory = SessionServiceFactory
    
    private var factory: Factory
    
    var userId: String = ""
    var userKey: String = ""
    var username: String = ""
    
    
    weak var delegate: SignInViewModelDelegate?
    
    init(factory: Factory) {
        self.factory = factory
    }
    
    
    
    func requestToSignIn(){
        factory.requestToLogin(userID: userId, userKey: userKey, username: username) { [weak self] (response) in
            switch response{
            case .success(_):
                self?.delegate?.onSuccesSignIn()
            case .failure(let err):
                self?.delegate?.onError(error: err)
            }
        }
    }
    
    
    
}
