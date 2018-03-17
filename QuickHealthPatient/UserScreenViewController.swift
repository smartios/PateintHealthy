//
//  UserScreenViewController.swift
//  QuickHealthPatient
//
//  Created by SL161 on 08/11/17.
//  Copyright © 2017 SL161. All rights reserved.
//

import UIKit

class UserScreenViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView = UITableView()
    @IBOutlet weak var callbuton: UIButton!
    var expandBool = false
    var imagetoset = "postlogin"
    
    var dataArray = ["PROFILE","HEALTH RECORD","HISTORY","TRACK","FAVOURITE DOCTORS","WAITING ROOM","LOGOUT"]
    
    var dataExpandArray = ["PROFILE","HEALTH RECORD","PHYSICAL STATS","MEDICAL HISTORY","FAMILY HISTORY","HISTORY","TRACK","FAVOURITE DOCTORS","WAITING ROOM","LOGOUT"]
    
    
    @IBOutlet weak var bgimage: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.tabBarController?.tabBar.items?[2].isEnabled = false
        //        self.tabBarController?.tabBar.items?[3].isEnabled = false
        // Do any additional setup after loading the view.
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = .clear
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        //login-2ipad
        //login
        if (size.width / size.height > 1) {
            // print("landscape")
            imagetoset = "postloginLandscape"
            self.tableView?.reloadData()
        } else {
            // print("portrait")
            imagetoset = "postlogin"
            self.tableView?.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expandBool == true
        {
            return dataExpandArray.count
        }else
        {
            return dataArray.count
        }
        
    }
    
    // MARK: - table view delegate methods
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("FAQHeader", owner: self, options: nil)?[0] as! UIView
        let bgImage = headerView.viewWithTag(11) as! UIImageView
        let profileImg = headerView.viewWithTag(12) as! UIImageView
        let editImg = headerView.viewWithTag(10) as! UIImageView
        editImg.isHidden = true
        let userName = headerView.viewWithTag(13) as! UILabel
        let idLbl = headerView.viewWithTag(-40) as! UILabel
        
        profileImg.layer.cornerRadius = (profileImg.frame.height)/2
        profileImg.clipsToBounds = true
        headerView.tag = section
        userName.font = UIFont(name: "OpenSans-Bold_0", size: 16)
        
        if UserDefaults.standard.object(forKey: "user_detail") != nil  {
            if "\(UserDefaults.standard.object(forKey: "user_detail")!)" != "" && (UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).count>0 &&  ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_image")) != nil &&
                ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_image")) as! String != ""
            {
                let image1 = ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_image")) as! String
                let image_url = image1
                
                profileImg.setImageWith(NSURL(string: image_url)! as URL, placeholderImage: UIImage(named: "landing_image"))
            }else
            {
                profileImg.image = UIImage(named: "landing_image")
            }
            
            
            if "\(UserDefaults.standard.object(forKey: "user_detail")!)" != "" && (UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).count>0  &&  ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "first_name")) != nil
                && ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "first_name")) as! String != ""
                && ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "last_name")) != nil
                && ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "last_name")) as! String != ""
            {
                userName.text =  ((((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "first_name")) as? String)! + " " + (((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "last_name")) as? String)!).uppercased()
            }
            
            idLbl.isHidden = false
            
            if let x = ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "unique_number") as? String)
            {
                idLbl.text = "ID-\(x)"
            }
        }
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        if indexPath.row == 0
        //        {
        //            if UIDevice.current.userInterfaceIdiom == .pad
        //            {
        //                return 316
        //            }else
        //            {
        //                return 216
        //            }
        //
        //        }
        //        else
        //        {
        return 50
        //        }
        
    }
    @IBAction func menuButtonClicked(sender: AnyObject) {
        onSlideMenuButtonPressed(sender as! UIButton)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        
        if indexPath.row == dataArray.count - 1 && expandBool == false
            
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "optionCell2")
            let profile_image = cell.viewWithTag(1) as! UIImageView
            let name_label = cell.viewWithTag(2) as! UILabel
            if expandBool == true
            {
                name_label.text = dataExpandArray[indexPath.row]
                
            }else
            {
                name_label.text = dataArray[indexPath.row]
            }
            profile_image.image = #imageLiteral(resourceName: "logout")
        }
            
            
        else if indexPath.row == dataExpandArray.count - 1 && expandBool == true
            
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "optionCell2")
            let profile_image = cell.viewWithTag(1) as! UIImageView
            let name_label = cell.viewWithTag(2) as! UILabel
            if expandBool == true
            {
                name_label.text = dataExpandArray[indexPath.row]
                
            }else
            {
                name_label.text = dataArray[indexPath.row]
            }
            profile_image.image = #imageLiteral(resourceName: "logout")
        }
            
        else
        {
            if expandBool == true && (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4)
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "optionCell3")
            }
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "optionCell")
            }
            let profile_image = cell.viewWithTag(1) as! UIImageView
            let name_label = cell.viewWithTag(2) as! UILabel
            if expandBool == true
            {
                name_label.text = dataExpandArray[indexPath.row]
                
            }else
            {
                name_label.text = dataArray[indexPath.row]
            }
            profile_image.image = #imageLiteral(resourceName: "arrow")
            
        }
        cell.backgroundColor = UIColor.clear
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if expandBool == false
        {
            if indexPath.row == 0
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 1
            {
                if expandBool == false
                {
                    expandBool = true
                }else
                {
                    expandBool = false
                }
                tableView.reloadData()
            }
            else if indexPath.row == 2
            {
                let vc = HistoryListViewController(nibName: "HistoryListViewController", bundle: nil)
//               let vc = RatingViewController(nibName: "RatingViewController", bundle: nil)
//                vc.from = "doctor"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 3
            {
                let vc =  TrackViewController(nibName: "TrackViewController", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 4
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AvailableDoctorsViewController") as! AvailableDoctorsViewController
                vc.commingFromView = "fromUserScreenvc"
                self.navigationController?.pushViewController(vc, animated: true)
            }
                
                
            else if indexPath.row == 5
            {
//                let vc = VideoCallViewController()
//                self.navigationController?.pushViewController(vc, animated: true)
                //                self.present(vc, animated: true, completion: nil)
            }
            else if indexPath.row == 6
            {
                let alertView = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                alertView.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alertAction) -> Void in
                    //self.logoutUser()
                    self.logoutUser()
                    return
                }))
                present(alertView, animated: true, completion: nil)
            }
        }else
        {
            if indexPath.row == 0
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 1
            {
                if expandBool == false
                {
                    expandBool = true
                }else
                {
                    expandBool = false
                }
                tableView.reloadData()
            }else if indexPath.row == 2
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhysicalStatsViewController") as! PhysicalStatsViewController
                vc.from = "userScreen"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 3
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MedicalHistoryView") as! MedicalHistoryView
                vc.from = "userScreen"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 4{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FamilyHistoryViewController") as! FamilyHistoryViewController
                vc.from = "userScreen"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 6
            {
                let vc =  TrackViewController(nibName: "TrackViewController", bundle: nil)
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
                
            else if indexPath.row == 5
            {
                let vc = HistoryListViewController(nibName: "HistoryListViewController", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
                
            else if indexPath.row == 7
            {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AvailableDoctorsViewController") as! AvailableDoctorsViewController
                vc.commingFromView = "fromUserScreenvc"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 8
            {
                //                let vc =  ThankYouViewController(nibName: "ThankYouViewController", bundle: nil)
                //
                //                self.present(vc, animated: true, completion: nil)
            }
            else if indexPath.row == 9
            {
                let alertView = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                alertView.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alertAction) -> Void in
                    //self.logoutUser()
                    self.logoutUser()
                    return
                }))
                present(alertView, animated: true, completion: nil)
            }
            else
                
            {
                // PaymentWebKitViewController
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentWebKitViewController") as! PaymentWebKitViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
            
            //            else if indexPath.row == 6
            //            {
            ////                AddDocumentsView
            //
            //            }
            //
            
        }
    }
    
    
    func logoutUser()
    {
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "user_detail")
        appDelegate.socketManager.closeConnection()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let pushVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let rootViewController = appDelegate.window!.rootViewController as! UINavigationController
        rootViewController.setViewControllers([pushVC], animated: true)
        appDelegate.window!.rootViewController!.removeFromParentViewController()
        appDelegate.window!.rootViewController!.view.removeFromSuperview()
        appDelegate.window!.rootViewController = nil
        appDelegate.window!.rootViewController = rootViewController
    }
}
