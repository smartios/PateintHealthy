//
//  AppDelegateRedirection.swift
//  QuickHealthPatient
//
//  Created by SL-167 on 3/5/18.
//  Copyright © 2018 SL161. All rights reserved.
//

import Foundation


class AppointmentNotification
{
    class func nurse_alloted(dataDic: NSMutableDictionary)
    {
        print("Nurse alloted to appointment =====\n \(dataDic)")
        let tempDict = ["appointment_id":dataDic.object(forKey: "id_appointment") as! String]
        let tabStoryboard: UIStoryboard = UIStoryboard(name: "TabbarStoryboard", bundle: nil)
        let vc = tabStoryboard.instantiateViewController(withIdentifier: "AppointmentDeatilsView") as! AppointmentDeatilsView
        vc.data = tempDict as! NSMutableDictionary
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func call_initiated(dataDic: NSMutableDictionary)
    {
        print("call initiated appointment =====\n \(dataDic)")
        appDelegate.socketManager.redirectionToCallScreen(dic: dataDic)
    }
    
    class func call_canceled(dataDic: NSMutableDictionary)
    {
        appDelegate.socketManager.call_canceled(dict: dataDic.mutableCopy() as! NSMutableDictionary)
    }
    
    class func call_reminder(dataDic: NSMutableDictionary)
    {
        let story = UIStoryboard(name: "TabbarStoryboard", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "AppointmentDeatilsView") as! AppointmentDeatilsView
        vc.appt_id = "\(dataDic.value(forKey: "id_appointment")!)"
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
