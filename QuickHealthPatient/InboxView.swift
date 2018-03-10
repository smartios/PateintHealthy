//
//  InboxView.swift
//  QuickHealthDoctorApp
//
//  Created by SS142 on 11/12/17.
//  Copyright © 2017 SS142. All rights reserved.
//

import UIKit

class InboxView: BaseViewController,UITableViewDataSource,UITableViewDelegate{
    
    var userInterface = UIDevice.current.userInterfaceIdiom
    @IBOutlet weak var norecord: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var inboxDic = NSMutableDictionary()
    var pagination = 0
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
        definesPresentationContext = true
        norecord.isHidden = true
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(InboxView.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func refresh()
    {
        pagination = 0
        
        if(inboxDic.value(forKey: "incoming_messages") != nil)
        {
            inboxDic.removeObject(forKey: "incoming_messages")
        }
        self.inboxListing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.inboxListing()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if  (tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.size.height)) && inboxDic.value(forKey: "inbox_count") != nil && Double(Int("\(inboxDic.value(forKey: "inbox_count")!)")!) > Double(Int("\((inboxDic.object(forKey: "incoming_messages") as! NSArray).count)")!)
        {
            //user has scrolled to the bottom
            pagination += 1
            inboxListing()
        }
    }
    
    
    //MARK:- TableView Delegate and Datasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "profileCell")!
        
        let patientImg = cell.viewWithTag(1) as! UIImageView
        let name = cell.viewWithTag(2) as! UILabel
        let message = cell.viewWithTag(3) as! UILabel
        let Patientdate = cell.viewWithTag(4) as! UIButton
        
        patientImg.layer.cornerRadius = patientImg.frame.width/2
        patientImg.clipsToBounds = true
        patientImg.layer.borderWidth = 1
        patientImg.layer.borderColor = UIColor.lightGray.cgColor
        cell.backgroundColor = UIColor.clear
        
        //
        if inboxDic.object(forKey: "incoming_messages") != nil &&  inboxDic.object(forKey: "incoming_messages") is NSNull == false && (inboxDic.object(forKey: "incoming_messages") as! NSArray).count > 0
        {
            
          
            patientImg.setImageWith(NSURL(string: "\(((inboxDic.value(forKey: "incoming_messages") as! NSArray).object(at: indexPath.row) as! NSDictionary).object(forKey: "sender_profile_image")!)")! as URL, placeholderImage: UIImage(named: "landing_image"))
            
            
            message.text = (((inboxDic.value(forKey: "incoming_messages") as! NSArray).object(at: indexPath.row) as! NSDictionary).object(forKey: "message") as! String)
            
            name.text = (((inboxDic.value(forKey: "incoming_messages") as! NSArray).object(at: indexPath.row) as! NSDictionary).object(forKey: "sender_first_name") as! String) + " " + (((inboxDic.value(forKey: "incoming_messages") as! NSArray).object(at: indexPath.row) as! NSDictionary).object(forKey: "sender_last_name") as! String)
            
            
            let time = (((inboxDic.value(forKey: "incoming_messages") as! NSArray).object(at: indexPath.row) as! NSDictionary).object(forKey: "added_on") as! String)
            
            Patientdate.setTitle(CommonValidations.getDateUTCStringFromDateString(date: time, fromDateString: "YYYY-MM-DD HH:mm:ss", toDateString: "HH:mm"), for: .normal)
            
        }
        
        return cell
    }
    
    func navigateToLogin()
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if((inboxDic.value(forKey: "incoming_messages") as! NSArray).count > 0)
        {
            let x = (((inboxDic.value(forKey: "incoming_messages") as! NSArray).object(at: indexPath.row) as! NSDictionary).object(forKey: "notification_type") as! String)
            
            if x == "new_appointment"
            {
                //            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PatientListView") as! PatientListView
                //            self.navigationController?.pushViewController(vc, animated: true)
            }
            else if x == "admin"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentDeatilsView") as! AppointmentDeatilsView
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentDeatilsView") as! AppointmentDeatilsView
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
       
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(inboxDic.value(forKey: "incoming_messages") != nil)
        {
            return (inboxDic.value(forKey: "incoming_messages") as! NSArray).count
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    @IBAction func detailPatientBtnTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentDeatilsView") as! AppointmentDeatilsView
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        onSlideMenuButtonPressed(sender )
    }
    
    //    MARK:- WebService Inbox Listing
    func inboxListing() {
        self.refreshControl.endRefreshing()
        self.norecord.isHidden = true
        
        supportingfuction.hideProgressHudInView(view: self)
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
       
        let dict = NSMutableDictionary()
        dict.setObject(UserDefaults.standard.object(forKey: "user_id")! as! String, forKey: "id_user" as NSCopying)
        dict.setValue(pagination, forKey: "pagination")
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPI(WebAPI.inbox, dict, { (operation, responseObject) in
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
//                    if(self.inboxDic.value(forKey: "incoming_messages") == nil || (self.inboxDic.value(forKey: "incoming_messages") as! NSArray).count == 0)
//                    {
                        let arr:NSMutableArray = (dataFromServer.object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
                        self.inboxDic.setValue(arr, forKey: "incoming_messages")
//                    }
//                    else
//                    {
//                         let arr:NSMutableArray = (self.inboxDic.value(forKey: "incoming_messages") as! NSArray).mutableCopy() as! NSMutableArray
//
//                        for a in 0..<(dataFromServer.object(forKey: "data") as! NSArray).count
//                        {
//                            arr.add(((dataFromServer.object(forKey: "data") as! NSArray).object(at: a) as! NSDictionary))
//                        }
//
//                        self.inboxDic.setValue(arr, forKey: "incoming_messages")
//                    }
                    
                    self.inboxDic.setValue("\(dataFromServer.value(forKey: "inbox_count")!)", forKey: "inbox_count")
                    
                    if(self.inboxDic.value(forKey: "incoming_messages") == nil || (self.inboxDic.value(forKey: "incoming_messages") as! NSArray).count == 0)
                    {
                        supportingfuction.showMessageHudWithMessage(message: "\(dataFromServer.value(forKey: "message")!)" as NSString, delay: 2.0)
                        //self.norecord.isHidden = false
                    }
                    
                    self.tableView?.reloadData()
                }
                else if(dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                
                    logoutUser()
                }
                else
                {
                    if(self.inboxDic.value(forKey: "incoming_messages") == nil || (self.inboxDic.value(forKey: "incoming_messages") as! NSArray).count == 0)
                    {
                        supportingfuction.showMessageHudWithMessage(message: "\(dataFromServer.value(forKey: "message")!)" as NSString, delay: 2.0)
                     //   self.norecord.isHidden = false
                    }
                }
            }
        }) { (operation, error) in
            supportingfuction.hideProgressHudInView(view: self)
            print(error.localizedDescription)
            
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        }
        
    }
}
