//
//  ChatRoomViewController.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import UIKit
import IQKeyboardManager

class ChatRoomViewController: UIViewController {
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var bottomConstraintTextFieldContainerOutlet: NSLayoutConstraint!
    @IBOutlet weak var textFieldOutlet: UITextField!
    
    typealias Factory =  ChatServiceFactory
    
    private let factory: Factory
    private let vm: ChatRoomViewModel
    private let room: ChatRoomModel
    
    private let notificationCenter = NotificationCenter.default
    private lazy var safeAreaInset: UIEdgeInsets? = {
        let window = UIApplication.shared.windows.first
        return window?.safeAreaInsets
    }()
    
    
    
    
    init(factory: Factory, room: ChatRoomModel) {
        self.factory = factory
        self.room = room
        self.vm = ChatRoomViewModel(factory: factory, roomID: room.id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
        setupUI()
        setupTextField()
        setupTableView()
        setupKeyboardObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardIQSetup(isEnable: false)
        vm.requestLastMessages()
//        vm.setChatServiceDelegate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardIQSetup(isEnable: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textFieldOutlet.layer.cornerRadius = 4
    }
    
    
    @IBAction func sendButtonAction(_ sender: Any) {
        vm.requestSendMessage()
    }
    
    @IBAction func attachButtonAction(_ sender: Any) {
        
    }
    
    
    @objc
    private func handleKeyboard(_ notification: Notification){
        
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        if notification.name == UIResponder.keyboardWillShowNotification{
            let height = keyboardFrame.cgRectValue.height
            let inset = (height -  bottomConstraintTextFieldContainerOutlet.constant)
            bottomConstraintTextFieldContainerOutlet?.constant = bottomConstraintTextFieldContainerOutlet?.constant == .zero ? inset : .zero
        }else{
            bottomConstraintTextFieldContainerOutlet?.constant = .zero
        }
        
        
        UIView.animate(withDuration: 0, animations: { [unowned self] in
            self.view.layoutIfNeeded()
            self.tableViewOutlet.tableViewScrollToBottom()
        })
    }
    
    private func setupTableView(){
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = vm
        tableViewOutlet.register(ChatTableViewCell.self)
    }
    
    
    private func setupUI(){
        navigationItem.title = room.name
        
    }
    
    private func setupTextField(){
        textFieldOutlet.delegate = self
    }
    
    private func setupKeyboardObserver(){
        notificationCenter.addObserver(self, selector: #selector(ChatRoomViewController.handleKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(ChatRoomViewController.handleKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func keyboardIQSetup(isEnable: Bool){
        if isEnable{
            IQKeyboardManager.shared().isEnabled = true
            IQKeyboardManager.shared().shouldResignOnTouchOutside = false
            IQKeyboardManager.shared().isEnableAutoToolbar = true
        }else{
            IQKeyboardManager.shared().isEnabled = false
            IQKeyboardManager.shared().shouldResignOnTouchOutside = true
            IQKeyboardManager.shared().isEnableAutoToolbar = false
        }
    }
    
    
}


extension ChatRoomViewController: ChatRoomViewModelDelegate{
    func onError(err: Error) {
        UIAlertController.basicAlert(title: "ERROR", message: err.localizedDescription, vc: self)
    }
    
    func onReloadData() {
        tableViewOutlet.reloadData()
        tableViewOutlet.tableViewScrollToBottom()
    }
    
    func onSuccesSendChat(){
        textFieldOutlet.text = ""
        vm.typeChat = ""
    }
}



extension ChatRoomViewController: UITableViewDelegate{
    
}

extension ChatRoomViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        vm.typeChat = textField.text ?? ""
    }
    
}



