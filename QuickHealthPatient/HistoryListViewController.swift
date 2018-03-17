//
//  HistoryListViewController.swift
//  QuickHealthPatient
//
//  Created by singsys on 2/3/18.
//  Copyright © 2018 SL161. All rights reserved.
//

import UIKit

class HistoryListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, fechedchildList {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var noRecordLabel: UILabel!
    @IBOutlet var historyCell: UITableViewCell!
    @IBOutlet var filter: UIButton!
    var historyListArray = NSMutableArray()
    //var refreshControl: UIRefreshControl!
    var filterKey = "all"
    var child_Id = "0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                //        refreshControl = UIRefreshControl()
        //        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        //        refreshControl.addTarget(self, action: #selector(HistoryListViewController.refresh), for: UIControlEvents.valueChanged)
        //        tableView.addSubview(refreshControl)
        history_list()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        page = 0
        //        self.dataArray.removeAllObjects()
        self.tableView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    
    
    /// Action performed when pull to refresh is called.
    @objc func refresh()
    {
        //        self.dataArray.removeAllObjects()
        self.tableView.reloadData()
        //        page = 0
       // self.refreshControl.endRefreshing()
    }
    
    
    //    MARK: - TableView Delegates
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return historyListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        Bundle.main.loadNibNamed("HistoryListCells", owner: self, options: nil)
        
        var cell:UITableViewCell!
        
        cell = tableView.dequeueReusableCell(withIdentifier: "historyCell")
        if cell == nil
        {
            cell = historyCell
            historyCell = nil
        }
        
        let profileImage = cell.viewWithTag(1) as! UIImageView
        let nameLabel = cell.viewWithTag(2) as! UILabel
        let IDLabel = cell.viewWithTag(4) as! UILabel
        let DateLabel = cell.viewWithTag(6) as! UILabel
        let TimeLabel = cell.viewWithTag(8) as! UILabel
        let typeLabel = cell.viewWithTag(9) as! UILabel
        let statusLabel = cell.viewWithTag(10) as! UILabel
        let favButton = cell.viewWithTag(3) as! UIButton
        let detailButton = cell.viewWithTag(11) as! UIButton
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.layer.borderWidth = 2.0
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        profileImage.clipsToBounds = true
        detailButton.layer.borderWidth = 1.0
        detailButton.layer.cornerRadius = 5.0
        detailButton.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0).cgColor
        
        
        let dic = (historyListArray.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        
        if let x = dic.object(forKey: "doctor_image") as? String
        {
            profileImage.setImageWith(NSURL(string: x)! as URL, placeholderImage: UIImage(named: "landing_image"))
        }else
        {
            profileImage.image = #imageLiteral(resourceName: "landing_image")
        }
        
        
        if let x = (dic.object(forKey: "doctor_name") as? String)
        {
            nameLabel.text = x
        }
        else
        {
            nameLabel.text = "NA"
        }
        
        
        if let x = (dic.object(forKey: "unique_number") as? String)
        {
            IDLabel.text = ("ID: \(x)")
        }
        else
        {
            IDLabel.text = "NA"
        }
        
        
        if dic.object(forKey: "call_updated_on") != nil && "\(dic.object(forKey: "call_updated_on")!)" != "" && "\(dic.object(forKey: "call_updated_on")!)" != "0000-00-00 00:00:00"
        {
            DateLabel.text = CommonValidations.getDateStringFromDateString(date: "\(dic.object(forKey: "call_updated_on")!)", fromDateString: "YYYY-MM-dd HH:mm:ss", toDateString: "dd MMM, YYYY")
            
            TimeLabel.text = CommonValidations.getDateStringFromDateString(date: "\(dic.object(forKey: "call_updated_on")!)", fromDateString: "YYYY-MM-dd HH:mm:ss", toDateString: "hh:mm a")
        }
        else
        {
            DateLabel.text = "NA"
            TimeLabel.text = "NA"
        }
        
        
        if let x = (dic.object(forKey: "service_title") as? String)
        {
            typeLabel.text = x
        }
        else
        {
            typeLabel.text = "NA"
        }
        
        
        if let x = (dic.object(forKey: "appointment_status") as? String), x != ""
        {
            statusLabel.text = x.uppercased()
            
        }
        else
        {
            statusLabel.text = "NA"
        }
        
        
        if let x = (dic.object(forKey: "fav_doc") as? String), x != ""
        {
            favButton.isSelected = true
        }
        else
        {
            favButton.isSelected = false
        }
        
        setCallStaus(status: statusLabel.text!, label: statusLabel)
        cell.selectionStyle = .none
        return cell
    }
    
    
    func setCallStaus(status:String,label:UILabel){
        
        switch status.lowercased() {
        case "accepted":
            label.textColor = CommonValidations.hexStringToUIColor(hex: "008000")
            break
        case "rejected":
            label.textColor = CommonValidations.hexStringToUIColor(hex: "ff0000")
            break
        case "cancelled":
            label.textColor = UIColor.black
            break
        case "completed":
            label.textColor = CommonValidations.hexStringToUIColor(hex: "35e45e")
            break
        case "pending":
            label.textColor = CommonValidations.hexStringToUIColor(hex: "ffcc34")
            break
        case "n/a":
            label.textColor = UIColor.darkGray
            break
        default:
            print(status)
        }
    }
    
    //MARK:- Action Method
    
    /// When user clicks on the button - Side Menu will be opened.
    ///
    /// - Parameter sender: UIButton
    
    func getChildId(code: String, ID: String) {
        
        if code == "Myself"
        {
            filterKey = "myself"
            child_Id = "0"
        }
        else if code == "All"
        {
            child_Id = "0"
            filterKey = "all"
        }
        else
        {
            child_Id = code
            filterKey = "child"
        }
        
        if(!appDelegate.hasConnectivity())
        {
            supportingfuction.showMessageHudWithMessage(message: NoInternetConnection as NSString, delay: 2.0)
        }
        else
        {
            history_list()
            
        }
    }
    
    
    @IBAction func filterBtn(_ sender: UIButton) {
        
        let story = UIStoryboard(name: "TabbarStoryboard", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "ChildListViewController") as! ChildListViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// When user clicks on the button - Pop back to screen.
    ///
    /// - Parameter sender: UIButton
    @IBAction func backButtontapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// When user clicks on the button - Open detail screen.
    ///
    /// - Parameter sender: UIButton
    @IBAction func detailButtontapped(_ sender: UIButton) {
        
        
    }
    
    /// When user clicks on the button - doctor is selected as favourite.
    ///
    /// - Parameter sender: UIButton
    @IBAction func favButtontapped(_ sender: UIButton) {
        
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView?.indexPathForRow(at: pointInTable)
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        
        if let x = ((historyListArray.object(at: cellIndexPath![1]) as! NSDictionary).object(forKey: "id_doctor") as? String)
        {
            dict.setObject(x, forKey: "id_doctor" as NSCopying)
        }
        
        dict.setObject(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "id_user" as NSCopying)
        
        if sender.isSelected == true
        {
            dict.setObject("0", forKey: "status" as NSCopying)
        }else
        {
            dict.setObject("1", forKey: "status" as NSCopying)
        }
        
        dict.setObject("patient", forKey: "account_type" as NSCopying)
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        
        let apiSniper = APISniper()
        
        apiSniper.getDataFromWebAPI(WebAPI.mark_as_favourite,dict, {(operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    self.history_list()
                    //                    if let x = (dataFromServer.object(forKey: "data") as? NSArray)
                    //                    {
                    //                        self.historyListArray = (x.mutableCopy() as! NSMutableArray)
                    //                    }
                    //                    self.tableView?.reloadData()
                }
                else if(dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
                }
                else
                {
                    if dataFromServer.object(forKey: "message") != nil
                    {
                        supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                    }
                }
            }
        }) { (operation, error) in
            supportingfuction.hideProgressHudInView(view: self)
            print(error.localizedDescription)
            
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        }
    }
    
    
    
    // MARK: - user_profile
    func history_list()
    {
        noRecordLabel.isHidden = true

        supportingfuction.hideProgressHudInView(view: self)
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        
        dict.setObject(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "id_user" as NSCopying)
        dict.setObject("patient", forKey: "user_type" as NSCopying)
        dict.setObject(filterKey, forKey: "filter_key" as NSCopying)
        dict.setObject(child_Id, forKey: "child_id" as NSCopying)
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        
        let apiSniper = APISniper()
        
        
        apiSniper.getDataFromWebAPI(WebAPI.history,dict, {(operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    if let x = (dataFromServer.object(forKey: "data") as? NSArray)
                    {
                        self.historyListArray = (x.mutableCopy() as! NSMutableArray)
                    }
                    
                    if(self.historyListArray.count == 0)
                    {
                        self.noRecordLabel.isHidden = false
                    }
                    
                    self.tableView?.reloadData()
                }
                else if(dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
                }
                else
                {
                    if dataFromServer.object(forKey: "message") != nil
                    {
//                        supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                        self.noRecordLabel.isHidden = false

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
