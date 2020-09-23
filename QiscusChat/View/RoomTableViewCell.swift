//
//  RoomTableViewCell.swift
//  QiscusChat
//
//  Created by Willa on 23/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import UIKit
import SDWebImage

class RoomTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var subtitleOutlet: UILabel!
    @IBOutlet weak var accessoriesTitleOutlet: UILabel!
    
    
    var chatRoom: ChatRoomModel?{
        didSet{
            
            if let avatarURL = chatRoom?.avatar{
                imageOutlet.sd_setImage(with: avatarURL)
            }
            titleOutlet.text = chatRoom?.name ?? ""
            subtitleOutlet.text = chatRoom?.commentBeforeID ?? ""
            accessoriesTitleOutlet.text = chatRoom?.displayDate ?? ""
            
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageOutlet.layer.roudCornerType(type: .rounded)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    

    
    
}
