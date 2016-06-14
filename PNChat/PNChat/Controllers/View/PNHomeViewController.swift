//
//  PNHomeViewController.swift
//  PNChat
//
//  Created by Nobuharu_Itoh on 2016/06/14.
//  Copyright © 2016年 Nobuharu Itoh. All rights reserved.
//

import UIKit

class PNHomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var tfNickName: UITextField!
    @IBOutlet var tfRoomName: UITextField!
    
    let segueName : String = "MessageSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: TextField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        if (textField == self.tfNickName) {
            self.tfRoomName.becomeFirstResponder()
        }
        return true
    }
    
    // MARK: Segue
    /**
     画面遷移時に、渡す値を設定する
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (self.segueName == segue.identifier) {
            let nextViewController: PNMessageListViewController = segue.destinationViewController as! PNMessageListViewController;
            nextViewController.setUserName(self.tfNickName.text!, roomName: self.tfRoomName.text!)
        }
    }
    
    /**
     条件により遷移させないなどの実装用
     */
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool
    {
        var result: Bool = false
        
        if self.checkNickNameField() && self.checkRoomNameField() {
            result = true;
        }
        
        if !result {
            let alert: UIAlertController = UIAlertController.init(title: "error", message: "message", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction) in
                
            }))
            self.navigationController?.presentViewController(alert, animated: true, completion: nil)
        }
        return result
    }
    
    func checkNickNameField() -> Bool
    {
        var result: Bool = false
        if let nick: String = self.tfNickName.text {
            if !nick.isEmpty {
                result = true
            }
        }
        return result
    }
    
    func checkRoomNameField() -> Bool
    {
        var result: Bool = false
        if let room: String = self.tfRoomName.text {
            if !room.isEmpty {
                result = true
            }
        }
        return result
    }
}
