//
//  SendModel.swift
//  PNChat
//
//  Created by 草間寛啓 on 2016/06/14.
//  Copyright © 2016年 Nobuharu Itoh. All rights reserved.
//

import Foundation

class SendModel {
    var nickName: String?
    var roomName: String?
    var uuid: String?
    
    init(nick: String, room: String, uuid: String) {
        self.nickName = nick
        self.roomName = room
        self.uuid = uuid
    }
    
    func sendString(message: String) -> String {
        let sendValue: String = self.nickName! + "," + message
        return sendValue
    }
}
