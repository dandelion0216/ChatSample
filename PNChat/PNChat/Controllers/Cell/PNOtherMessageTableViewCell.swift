//
//  PNOtherMessageTableViewCell.swift
//  PNChat
//
//  Created by 草間寛啓 on 2016/06/14.
//  Copyright © 2016年 Nobuharu Itoh. All rights reserved.
//

import UIKit

class PNOtherMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
