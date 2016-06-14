//
//  PNMessageListViewController.swift
//  PNChat
//
//  Created by Nobuharu_Itoh on 2016/06/14.
//  Copyright © 2016年 Nobuharu Itoh. All rights reserved.
//

import UIKit
import SpriteKit
import Moscapsule

class PNMessageListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var messageTableView: UITableView!
    @IBOutlet var inputArea: UIView!
    @IBOutlet var inputTextView: UITextView!
    
    var userName : String!
    var roomName : String!
    
    var mqttConf : MQTTConfig!
    var mqttClient : MQTTClient!
    
    let uuid = NSUUID().UUIDString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = roomName
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let const: Const = Const()
        // MQTT config init
        mqttConf = MQTTConfig(clientId: uuid, host: const.MQTT_HOST, port: const.MQTT_PORT, keepAlive: 60)
        // auth
        mqttConf.mqttAuthOpts = MQTTAuthOpts(username: const.MQTT_USER, password: const.MQTT_PW)
        // セッションを毎度クリアするって設定？
        mqttConf.cleanSession = true
        mqttConf.onMessageCallback = { mqttMessage in
            // TODO:
            dispatch_async(dispatch_get_main_queue(), {
                self.reloadMessages(mqttMessage)
            })
        }
        
        mqttClient = MQTT.newConnection(mqttConf)
        mqttClient.subscribe(const.MQTT_USER + "/" + roomName, qos: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendAction(sender: AnyObject)
    {
        let const: Const = Const()
        mqttClient.publishString("test", topic: const.MQTT_USER + "/" + roomName , qos: 0, retain: false)
    }
    
    /**
     ユーザー名とルームの設定
     
     - parameter userName: ユーザー名（ニックネーム）
     - parameter roomName: ルーム名
     */
    internal func setUserName(userName: String, roomName: String)
    {
        self.userName = userName
        self.roomName = roomName
    }
    
    func reloadMessages(messages: MQTTMessage) {
        let test = messages.payloadString
        NSLog("message : %@", test! as NSString)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        return UITableViewCell.init()
    }
}
