//
//  PNMeMessageTableViewCell.swift
//  PNChat
//
//  Created by Nobuharu_Itoh on 2016/06/14.
//  Copyright © 2016年 Nobuharu Itoh. All rights reserved.
//

import UIKit

class PNMeMessageTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
