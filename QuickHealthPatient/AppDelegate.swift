
//
//  AppDelegate.swift
//  QuickHealthPatient
//
//  Created by SL161 on 18/09/17.
//  Copyright © 2017 SL161. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import GooglePlaces
import CoreLocation
import CoreData
import GoogleMaps
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
     var chatMessages = NSMutableArray()
    var socketManager = SocketIOManager()
    var staticpage = ""
    var gameTimer: Timer!
    var timer: Timer!
    var locationManager: CLLocationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if(UserDefaults.standard.value(forKey: "ongoing_id_appointment") != nil)
        {
            UserDefaults.standard.removeObject(forKey: "ongoing_id_appointment")
        }

        GMSServices.provideAPIKey("AIzaSyBBVXutvuWZ9s2Y42Q__PnWvx5JPmxdWzw")
        GMSPlacesClient.provideAPIKey("AIzaSyBBVXutvuWZ9s2Y42Q__PnWvx5JPmxdWzw")
        Fabric.with([Crashlytics.self])
        
        if UserDefaults.standard.object(forKey: "is_firstTime") == nil    
        {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let pushVC = mainStoryboard.instantiateViewController(withIdentifier: "LandngScreen") as! LandngScreen
            let rootViewController = self.window!.rootViewController as! UINavigationController
            rootViewController.setViewControllers([pushVC], animated: false)
            rootViewController.isNavigationBarHidden = true
            appDelegate.window!.rootViewController!.removeFromParentViewController()
            appDelegate.window!.rootViewController!.view.removeFromSuperview()
            appDelegate.window!.rootViewController = nil
            appDelegate.window!.rootViewController = rootViewController
        }else
        {
            if UserDefaults.standard.object(forKey: "user_id") != nil
            {
                
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "TabbarStoryboard", bundle: nil)
                let pushVC = mainStoryboard.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
                let rootViewController = self.window!.rootViewController as! UINavigationController
                rootViewController.setViewControllers([pushVC], animated: false)
                rootViewController.isNavigationBarHidden = true
                appDelegate.window!.rootViewController!.removeFromParentViewController()
                appDelegate.window!.rootViewController!.view.removeFromSuperview()
                appDelegate.window!.rootViewController = nil
                appDelegate.window!.rootViewController = rootViewController
                //pushVC.selectedIndex = 
            }
            else
            {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let pushVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let rootViewController = self.window!.rootViewController as! UINavigationController
                rootViewController.setViewControllers([pushVC], animated: false)
                rootViewController.isNavigationBarHidden = true
                appDelegate.window!.rootViewController!.removeFromParentViewController()
                appDelegate.window!.rootViewController!.view.removeFromSuperview()
                appDelegate.window!.rootViewController = nil
                appDelegate.window!.rootViewController = rootViewController
            }
        }
        
        
        locationManager.requestWhenInUseAuthorization()
        
        if(!appDelegate.hasConnectivity())
        {
            supportingfuction.showMessageHudWithMessage(message: NoInternetConnection as NSString, delay: 2.0)
        }
        else
        {
            getApiToken(completionHandler: {(data) in
                
            })
        }
        
        //Register for remote notification
        self.registerForPushNotifications()
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        if UserDefaults.standard.object(forKey: "user_id") != nil && UserDefaults.standard.object(forKey: "user_id")! as! String != ""
        {
            appDelegate.socketManager.isApplicationInBackground = true
            socketManager.closeConnection()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        if UserDefaults.standard.object(forKey: "user_id") != nil && UserDefaults.standard.object(forKey: "user_id")! as! String != ""
        {
            socketManager.establishConnection()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
   
    
    //MARK: <-- Check for Internet Connection -->
    func hasConnectivity() -> Bool
    {
        let reachability: Reachability = Reachability(hostName:"www.google.com")
        let networkStatus: NetworkStatus = reachability.currentReachabilityStatus()
        return networkStatus != NetworkStatus.NotReachable
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        //Deeplinking used for frogot password
        if (url.scheme == "quickhealthpaitent")
        {
            let mathString: String = url.absoluteString
            let numbers = mathString.components(separatedBy: ["=", "?", ","])
            print(numbers)
            if numbers[2] == "1"
            {
                presentChangePassword(user_id: numbers[3])
            }else
            {
                supportingfuction.showMessageHudWithMessage(message: "invalid Link.", delay: 2.0)
                return false
            }
            if numbers[3] != ""
            {
                UserDefaults.standard.set(numbers[3], forKey: "user_id_frgtpass")
            }
            return true
        }
        
        return true
    }
    func presentChangePassword(user_id:String)
    {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let changePassVC = mainStoryboard.instantiateViewController(withIdentifier: "ResetPasswordView") as! ResetPasswordView
        let rootViewController = self.window!.rootViewController as! UINavigationController
        changePassVC.user_id = user_id
        rootViewController.pushViewController(changePassVC, animated: true)
    }
    
    
    // api_token
    func getApiToken(completionHandler:@escaping (_ data:Bool) -> Void)
    {
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        dict.setObject("api@quickhealth.com", forKey: "client_id" as NSCopying)
        dict.setObject("b37201a0a2bc7bcbc69e454afa56f2e60b054e9711b855725c1daec15223aaa5", forKey: "client_secret" as NSCopying)
        dict.setObject("client_credentials", forKey: "grant_type" as NSCopying)
        dict.setObject("patient", forKey: "scope" as NSCopying)
        
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPItoken(WebAPI.api_token,dict,{ (operation, responseObject) in
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                
                if dataFromServer.object(forKey: "access_token") != nil && dataFromServer.object(forKey: "access_token") as! String != ""
                {
                   UserDefaults.standard.set((dataFromServer.object(forKey: "access_token") as! String), forKey: "access_token")
                    
                    completionHandler(true)
                }else
                {
                  UserDefaults.standard.set("", forKey: "access_token")   
                }
            }
        }) { (operation, error) in
            supportingfuction.hideProgressHudInView(view: self)
            print(error.localizedDescription)
            
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        }
    }
    

}
extension UIView{
    func addGradientLayerToView(colors:[Any]){
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors
        gradient.anchorPoint = CGPoint(x: 0, y: 0)
        gradient.position = CGPoint(x: 0, y: 0)
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0);
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0);
        self.layer.insertSublayer(gradient, at: 0)
        
}
}
