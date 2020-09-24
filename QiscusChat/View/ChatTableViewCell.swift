//
//  ChatTableViewCell.swift
//  QiscusChat
//
//  Created by Willa on 24/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var contentViewOutlet: UIView!
    @IBOutlet weak var contentTitleOutlet: UILabel!
    @IBOutlet weak var dateTitleOutlet: UILabel!
    @IBOutlet weak var statusTitleOutlet: UILabel!
    
    
    var item: ChatModel?{
        didSet{
            contentTitleOutlet.text = item?.message
            dateTitleOutlet.text = item?.date.toString(format: "HH:mm")
            statusTitleOutlet.text = item?.status.rawValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentViewOutlet.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.4941176471, blue: 0.9843137255, alpha: 1)
        contentTitleOutlet.textColor = .white
        contentViewOutlet.layer.cornerRadius = 4
        dateTitleOutlet.textColor = .white
        statusTitleOutlet.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentViewOutlet.layer.cornerRadius = 4
    }
    
}
