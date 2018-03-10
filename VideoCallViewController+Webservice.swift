//
//  VideoCallViewController+Webservice.swift
//  QuickHealthPatient
//
//  Created by SL-167 on 3/5/18.
//  Copyright © 2018 SL161. All rights reserved.
//

import Foundation

extension VideoCallViewController
{}
//{
//
//    func disconnect_call_webservice()
//    {
//        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
//
//        let dict = NSMutableDictionary()
//        dict.setObject(UserDefaults.standard.object(forKey: "ongoing_id_appointment") as! String, forKey: "id_appointment" as NSCopying)
//
//        let time = self.timeString(time: TimeInterval(timeRemaining))
//        dict.setObject("\(time)", forKey: "exact_call_duration" as NSCopying)
//
//        let apiSniper = APISniper()
//        apiSniper.getDataFromWebAPI(WebAPI.Disconnect_Call, dict, { (operation, responseObject) in
//
//            supportingfuction.hideProgressHudInView(view: self)
//
//            if let dataFromServer = responseObject as? NSDictionary
//            {
//                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
//                {
//                    _ = self.navigationController?.popToRootViewController(animated: true)
//                }
//                else
//                {
//                    if dataFromServer.object(forKey: "message") != nil
//                    {
//                        supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
//                    }
//                }
//            }
//
//        }) { (operation, error) in
//            supportingfuction.hideProgressHudInView(view: self)
//            print(error.localizedDescription)
//
//            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
//        }
//    }
//
//
//}




