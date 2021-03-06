//
//  UITableView+Extension.swift
//  QiscusChat
//
//  Created by Willa on 23/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import UIKit

extension UITableView{
    
    /// Register custom table cell to it;s table view
    /// - Parameter type: TableViewCell type
    func register(_ type: UITableViewCell.Type) {
        let className = String(describing: type)
        register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
    }
    
    
    /// Deque a tableview cell to the tableview, and return UITableViewCell with the given type
    /// In order to make this work, the first  step is register a custom table the corespond table view,
    /// - Parameter type: TableViewCell Type
    /// - Returns: TableViewCell with the given type
    func dequeueReusableCell<T>(_ type: T.Type) -> T? {
        let className = String(describing: type)
        return dequeueReusableCell(withIdentifier: className) as? T
    }
    
    /// table view scroll to bottom
    /// - Parameter animated: animation, default is true
    func tableViewScrollToBottom(animated: Bool = true) {
        let sections = self.numberOfSections
        let rows = self.numberOfRows(inSection: sections - 1)
        if (rows > 0){
            self.scrollToRow(at: IndexPath(row: rows - 1, section: sections - 1), at: .bottom, animated: animated)
        }
    }
}
