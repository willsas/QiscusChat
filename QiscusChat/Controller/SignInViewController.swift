//
//  SignInViewController.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var userIdTextFieldOutlet: UITextField!
    @IBOutlet weak var userKeyTextFieldOutlet: UITextField!
    @IBOutlet weak var displayNameTextFieldOutlet: UITextField!
    
    typealias Factory = SessionServiceFactory & CoordinatorFactory
    private let factory: Factory
    
    private let vm: SignInViewModel
    
    private lazy var coordinator: SignInCoordinator = {
        return factory.makeSignInCoordinator(vc: self)
    }()
    
    
    init(factory: Factory) {
        self.factory = factory
        self.vm = SignInViewModel(factory: factory)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
        setupUI()
        setupTextField()
        
    }
    
    
    
    // Actions
    @IBAction func signInButtonAction(_ sender: Any) {
        print("username: \(vm.username)")
        print("userid: \(vm.userId)")
        print("userkey: \(vm.userKey)")
        vm.requestToSignIn()
    }
    
    
    /// Setup view controller screen ui
    private func setupUI(){
        navigationItem.title = "Sign In"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    
    /// Setup textfield  delegate
    private func setupTextField(){
        userIdTextFieldOutlet.delegate = self
        userKeyTextFieldOutlet.delegate = self
        displayNameTextFieldOutlet.delegate = self
    }
    
}

// MARK: UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case userIdTextFieldOutlet:
            vm.userId = textField.text ?? ""
            
        case userKeyTextFieldOutlet:
            vm.userKey = textField.text ?? ""
            
        case displayNameTextFieldOutlet:
            vm.username = textField.text ?? ""
            
        default:
            break
        }
    }
}


// MARK: SignInViewModelDelegate
extension SignInViewController: SignInViewModelDelegate{
    
    func onError(error: Error) {
        UIAlertController.basicAlert(title: "ERROR", message: error.localizedDescription, vc: self)
    }
    
    func onSuccesSignIn() {
        coordinator.switchToChatListViewController()
    }
    
    
}
