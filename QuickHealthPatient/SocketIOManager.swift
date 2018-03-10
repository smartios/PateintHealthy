//
//  SocketIOManager.swift
//  SocketChat
//
//  Created by Gabriel Theodoropoulos on 1/31/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import UserNotifications

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    
    internal private(set) var status = SocketIOClientStatus.notConnected
    
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "https://quickhealth4u.com:9042")! as URL, config:[.reconnects(true), .reconnectAttempts(5), .reconnectWait(20), .log(false), .forcePolling(false), .forceWebsockets(false),.forceNew(false),.secure(false),.selfSigned(false)]);
    //    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "http://192.168.45.67:3212/")! as URL, config:[.reconnects(true), .reconnectAttempts(5), .reconnectWait(20), .log(false), .forcePolling(false), .forceWebsockets(false),.forceNew(false),.secure(false),.selfSigned(false)]);
    
    
    var isApplicationInBackground = false
    var isConnectedWithSocket = SocketIOClientStatus.notConnected
    
    
    override init() {
        super.init()
    }
    
    
    func establishConnection()
    {
        self.closeConnection()
        print("establishing connection...")
        socket.connect()
    }
    
    func closeConnection()
    {
        print("closing connection...")
        socket.disconnect()
    }
    
    
    func connectToServerWithNickname(nickname: String, completionHandler: (_ userList: [[String: AnyObject]]?) -> Void)
    {
        
        let params = NSMutableDictionary()
        if(UserDefaults.standard.value(forKey: "user_detail") != nil)
        {
            params.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "first_name")!)", forKey: "first_name")
            params.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "last_name")!)", forKey: "last_name")
            params.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "id_user")!)", forKey: "user_id")
            params.setValue("\(UserDefaults.standard.value(forKey: "access_token")!)", forKey: "access_token")
            params.setValue("\(WebAPI.BASE_URLs)connect-patient", forKey: "doctor_redirect_url")
        }
        else
        {
            return
        }
        //let user = (UserDefaults.standard.object(forKey: "local_user_details") as? NSDictionary)
        if(params.count > 0)
        {
            socket.emitWithAck("join", params).timingOut(after: 0, callback: { (data) in
                self.addListeners()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "call_accept_socket_not_connected"), object: nil)
                print(data)
                if (data as NSArray).object(at: 0) is NSString == true{
                    self.connectToServerWithNickname(nickname: "", completionHandler: { (userList) -> Void in  })
                    return
                }
            })
        }
    }
    
    //MARK:- Function to send videocall request
    
    
    func call_accepted(dataDic: NSMutableDictionary, accepted: Bool)
    {
        let params = NSMutableDictionary()
        
        if(accepted)
        {
            params.setValue("TRUE", forKey: "call_accepted")
            params.setValue("received", forKey: "client_call_status")
        }
        else
        {
            params.setValue("FALSE", forKey: "call_accepted")
            params.setValue("decline", forKey: "client_call_status")
        }
        params.setValue("\(UserDefaults.standard.value(forKey: "access_token")!)", forKey: "access_token")
        params.setValue("\(dataDic.value(forKey: "id_doctor")!)", forKey: "id_doctor")
        params.setValue("\(dataDic.value(forKey: "id_appointment")!)", forKey: "id_appointment")
        
        socket.emitWithAck("call_accepted", params).timingOut(after: 0, callback: { (data) in
            print(data)
        })
    }
    
    func addListeners()
    {
        socket.on("patient_accept_call") { (dataFromServer: [Any], SocketAckEmitter) in
            if let dic = (dataFromServer as NSArray)[0] as? NSDictionary
            {
                self.redirectionToCallScreen(dic: dic.mutableCopy() as! NSMutableDictionary)
            }
        }
        
        socket.on("confirm_call_cancelled") { (dataFromServer: [Any], SocketAckEmitter) in
            if let dic = (dataFromServer as NSArray)[0] as? NSDictionary
            {
                print(dic)
                self.call_canceled(dict: dic.mutableCopy() as! NSMutableDictionary)
            }
        }
    }
    
    func call_canceled(dict: NSMutableDictionary)
    {
        if let x = (dict.value(forKey: "id_appointment") as? String)
        {
            if UserDefaults.standard.value(forKey: "ongoing_id_appointment") != nil && x == UserDefaults.standard.object(forKey: "ongoing_id_appointment") as! String
            {
                let vc1 = UIApplication.topViewController()
                if vc1 is WaitingRoomViewController || vc1 is VideoCallViewController
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "call_canceled"), object: nil)
                }
            }
        }
    }
    
    func redirectionToCallScreen(dic: NSMutableDictionary)
    {
        let vc1 = UIApplication.topViewController()
        if vc1 is VideoCallViewController{
            
            if let x = (dic.value(forKey: "id_appointment") as? String)
            {
                if x != UserDefaults.standard.object(forKey: "ongoing_id_appointment") as! String
                {
                    
                    if #available(iOS 10.0, *) {
                        
                        let localNotification = UNMutableNotificationContent()
                        localNotification.title = "You have new call from \((dic.value(forKey: "user_detail") as! NSDictionary).value(forKey: "first_name")!) \((dic.value(forKey: "user_detail") as! NSDictionary).value(forKey: "last_name")!)"
                        localNotification.categoryIdentifier = "message"
                        
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.0, repeats: false)
                        
                        let request = UNNotificationRequest(identifier: "call_initiated", content: localNotification, trigger: trigger)
                        
                        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            // Your code with delay
                            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["call_initiated"])
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    //                    localNotification.fireDate = NSDate(timeIntervalSinceNow: 0) as Date
                    //                    localNotification.alertBody = "You have new call from \((dic.value(forKey: "user_detail") as! NSDictionary).value(forKey: "first_name")!) \((dic.value(forKey: "user_detail") as! NSDictionary).value(forKey: "last_name")!)"
                    //                    localNotification.alertAction = ""
                    //                    localNotification.timeZone = NSTimeZone.default
                    //                    UIApplication.shared.scheduleLocalNotification(localNotification)
                    
                    
                    
                    //                            print(dic)
                    
                    //
                    
                    //                            if let x = (dic.object(forKey: "id_doctor") as? String)
                    
                    //                            {
                    
                    //                                let alertContoller = UIAlertController(title: "Missed Call", message: "You have a missed call from doctor with id \(x).", preferredStyle: .alert)
                    
                    //                                let yesAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    //                                alertContoller.addAction(yesAction)
                    
                    //                                vc1?.present(alertContoller, animated: true, completion: nil)
                    
                    //
                    return
                }
            }
        }else{
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "remove_rating_screen"), object: nil)
            
            if(dic.value(forKey: "id_appointment") != nil)
            {
                UserDefaults.standard.setValue("\(dic.value(forKey: "id_appointment")!)", forKey: "ongoing_id_appointment")
            }
            
            if(dic.value(forKey: "token") != nil)
            {
                kToken = "\(dic.value(forKey: "token")!)"
            }
            
            if(dic.value(forKey: "tokbox_api_key") != nil)
            {
                kApiKey = "\(dic.value(forKey: "tokbox_api_key")!)"
            }
            
            if(dic.value(forKey: "session_id") != nil)
            {
                kSessionId = "\(dic.value(forKey: "session_id")!)"
            }
            
            let vc = VideoCallViewController()
            vc.dataDic = dic.mutableCopy() as! NSMutableDictionary
            vc1?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
