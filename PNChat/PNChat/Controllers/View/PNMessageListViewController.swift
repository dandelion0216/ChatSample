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

class PNMessageListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    @IBOutlet var messageTableView: UITableView!
    @IBOutlet var inputArea: UIView!
    @IBOutlet var inputTextView: UITextView!
    
    var userName : String!
    var roomName : String!
    
    var mqttConf : MQTTConfig!
    var mqttClient : MQTTClient!
    
    let uuid = NSUUID().UUIDString
    
    var items: [ResponseMessage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = roomName
        
        // notificationCenter
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(PNMessageListViewController.handleKeyboardWillShowNotification(_:)),
                                       name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(PNMessageListViewController.handleKeyboardWillHideNotification(_:)),
                                       name: UIKeyboardWillHideNotification, object: nil)
        
        self.messageTableView.registerNib(UINib.init(nibName: "PNMeMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "PNMeMessageTableViewCell")
        self.messageTableView.registerNib(UINib.init(nibName: "PNOtherMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "PNOtherMessageTableViewCell")
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
            let str: String = mqttMessage.payloadString!
            let responseMessage = ResponseMessage()
            responseMessage.parseMessage(str, id: mqttMessage.messageId)
            dispatch_async(dispatch_get_main_queue(), {
                self.reloadMessages(responseMessage)
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
        let send: SendModel = SendModel.init(nick: self.userName, room: self.roomName, uuid: self.uuid)
        mqttClient.publishString(send.sendString(self.inputTextView.text), topic: const.MQTT_USER + "/" + roomName , qos: 0, retain: false)
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
    
    func reloadMessages(parsedMessage: ResponseMessage)
    {
        self.items.append(parsedMessage)
        self.messageTableView.reloadData()
        self.inputTextView.resignFirstResponder()
        self.view.transform = CGAffineTransformIdentity
    }
    
    // handleKeyboardWillShowNotification
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        
        let userInfo               = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let transform  = CGAffineTransformMakeTranslation(0, -keyboardScreenEndFrame.size.height);
        self.view.transform = transform
    }
    
    // handleKeyboardWillShowNotification
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        self.view.transform = CGAffineTransformIdentity
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let resMsg = items[indexPath.row]
        if resMsg.nickName == self.nibName {
            let cell: PNMeMessageTableViewCell = tableView.dequeueReusableCellWithIdentifier("PNMeMessageTableViewCell", forIndexPath: indexPath) as! PNMeMessageTableViewCell
            cell.nameLabel.text = resMsg.nickName
            cell.messageLabel.text = resMsg.message
            return cell
            
        } else {
            let cell: PNOtherMessageTableViewCell = tableView.dequeueReusableCellWithIdentifier("PNOtherMessageTableViewCell", forIndexPath: indexPath) as! PNOtherMessageTableViewCell
            cell.nameLabel.text = resMsg.nickName
            cell.messageLabel.text = resMsg.message
            return cell
        }
    }
}
