//
//  Appdelegate+Notification.swift
//  QuickHealthDoctorApp
//
//  Created by SS042 on 28/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import Foundation
import UserNotifications

enum NotificationType: String
{
    case Nurse_Alloted = "nurse_allotment_notifications"
    case Call_Initiated = "initiate_call"
    case Call_Canceled = "confirm_call_cancelled"
    case Call_Reminder = "call_reminder"
}

extension AppDelegate{
    
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                print("Permission granted: \(granted)")
                guard granted else { return }
                self.getNotificationSettings()
            }
        } else {
            // Fallback on earlier versions
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                
                DispatchQueue.main.async(execute: {() -> Void in
                   UIApplication.shared.registerForRemoteNotifications()
                })
                
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        UserDefaults.standard.set("\(token)", forKey: "device_token")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
        UserDefaults.standard.set("", forKey: "device_token")
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let aps = userInfo["aps"] as! [String: AnyObject]
        self.handleNotifiaction(notificationData: aps as NSDictionary)
    }
    
    //Handle Notifiaction
    func handleNotifiaction(notificationData:NSDictionary)
    {
        print("Notification Data")
        
        if("\(notificationData.value(forKey: "notification_type")!)" == NotificationType.Nurse_Alloted.rawValue)
        {
            AppointmentNotification.nurse_alloted(dataDic: notificationData.mutableCopy() as! NSMutableDictionary)
        }
        else if("\(notificationData.value(forKey: "notification_type")!)" == NotificationType.Call_Initiated.rawValue)
        {
            AppointmentNotification.call_initiated(dataDic: notificationData.mutableCopy() as! NSMutableDictionary)
        }
        else if("\(notificationData.value(forKey: "notification_type")!)" == NotificationType.Call_Canceled.rawValue)
        {
            AppointmentNotification.call_canceled(dataDic: notificationData.mutableCopy() as! NSMutableDictionary)
        }
        else if("\(notificationData.value(forKey: "notification_type")!)" == NotificationType.Call_Reminder.rawValue)
        {
            AppointmentNotification.call_reminder(dataDic: notificationData.mutableCopy() as! NSMutableDictionary)
        }
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // 1
        let userInfo = response.notification.request.content.userInfo
        let aps = userInfo["aps"] as! [String: AnyObject]
        self.handleNotifiaction(notificationData: aps as NSDictionary)
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        //notification_type
        let userInfo = notification.request.content.userInfo
        let aps = userInfo["aps"] as! [String: AnyObject]
        
        
        if(UIApplication.shared.applicationState != .background && "\((aps as NSDictionary).value(forKey: "notification_type")!)" == NotificationType.Call_Initiated.rawValue)
        {
            completionHandler([])
            self.handleNotifiaction(notificationData: aps as NSDictionary)
        }
        else
        {
            completionHandler([.alert,.badge,.sound])
        }
    }
}
