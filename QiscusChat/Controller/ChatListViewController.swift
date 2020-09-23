//
//  ChatListViewController.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController {
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    typealias Factory =  CoordinatorFactory & ChatServiceFactory
    
    private let factory: Factory
    private let vm: ChatListViewModel
    
    private var refresherControl = UIRefreshControl()
    private lazy var coordinator: ChatListCoordinator = {
        return factory.makeChatListCoordinator(vc: self)
    }()
    
    
    
    init(factory: Factory) {
        self.factory = factory
        self.vm = ChatListViewModel(factory: factory)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
        setupUI()
        setupTableView()
        vm.requestChatRooms()
    }
    
    
    // Actions
    @objc
    private func refreshRoom(_ sender: UIRefreshControl){
        vm.requestChatRooms()
    }
    
    
    
    /// Setup  view controerl  UI related
    private func setupUI(){
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Chats"
    }
    
    
    /// Setup table view delegate, datasource, ui, and refreseher control
    private func setupTableView(){
        tableViewOutlet.dataSource = vm
        tableViewOutlet.delegate = self
        tableViewOutlet.register(RoomTableViewCell.self)
        tableViewOutlet.refreshControl = refresherControl
        refresherControl.addTarget(self, action: #selector(ChatListViewController.refreshRoom(_:)), for: .valueChanged)
        
    }
    
    
    /// Remove spinner in refresher control
    private func removeSpinner(){
        refresherControl.endRefreshing()
    }

}


extension ChatListViewController: ChatListViewModelDelegate{
    
    func onReloadData() {
        removeSpinner()
        tableViewOutlet.reloadData()
    }
    
    func onError(err: Error) {
        UIAlertController.basicAlert(title: "ERROR", message: err.localizedDescription, vc: self)
    }
    
}


extension ChatListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
