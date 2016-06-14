//
//  ResponseMessage.swift
//  PNChat
//
//  Created by 草間寛啓 on 2016/06/14.
//  Copyright © 2016年 Nobuharu Itoh. All rights reserved.
//

import Foundation

class ResponseMessage {
    var nickName: String?
    var message: String?
    var messageID: Int?
    
    internal func parseMessage(message: String, id: Int) {
        let data : [String] = message.characters.split(",").map{ String($0) }
        self.messageID = id
        
        
        self.nickName = data[0]
        self.message = data[1]
    }
}
