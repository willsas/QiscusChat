//
//  ChatRoomViewController.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import UIKit
import IQKeyboardManager
import QiscusCore

class ChatRoomViewController: UIViewController {
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var bottomConstraintTextFieldContainerOutlet: NSLayoutConstraint!
    @IBOutlet weak var textFieldOutlet: UITextField!
    
    typealias Factory =  ChatServiceFactory
    
    private let factory: Factory
    private let vm: ChatRoomViewModel
    private let room: ChatRoomModel
    private let roomModel: RoomModel
    
    private let notificationCenter = NotificationCenter.default
   
    
    init(factory: Factory, room: (RoomModel, ChatRoomModel)) {
        self.factory = factory
        self.room = room.1
        self.roomModel = room.0
        self.vm = ChatRoomViewModel(factory: factory, room: room.0)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        notificationCenter.removeObserver(self)
        print("\(self.description) deinit")
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardIQSetup(isEnable: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textFieldOutlet.layer.cornerRadius = 4
    }
    
    
    // Actions
    
    @IBAction func sendButtonAction(_ sender: Any) {
        vm.requestSendMessage()
    }
    
    @IBAction func attachButtonAction(_ sender: Any) {
        print("attach file button tapped")
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
    
    
    /// Setup tableview delegate datasource and register cell
    private func setupTableView(){
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = vm
        tableViewOutlet.register(ChatTableViewCell.self)
    }
    
    
    /// Setup view controller ui
    private func setupUI(){
        navigationItem.title = room.name
        navigationItem.largeTitleDisplayMode = .never
    }
    
    
    private func setupTextField(){
        textFieldOutlet.delegate = self
    }
    
    /// Observe keyboard frame changes
    private func setupKeyboardObserver(){
        notificationCenter.addObserver(self, selector: #selector(ChatRoomViewController.handleKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(ChatRoomViewController.handleKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    /// Enable and disableing IQKeyboard setup, should touch outside, and toolbar
    /// - Parameter isEnable: is enable IQ keyboard
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

// MARK: ChatRoomViewmodelDelegate
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


// MARK: UITableViewDelegate
extension ChatRoomViewController: UITableViewDelegate{
    
}

// MARK: UITTextFieldDelegate
extension ChatRoomViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        vm.typeChat = textField.text ?? ""
    }
    
}



