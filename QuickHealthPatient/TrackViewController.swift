//
//  TrackViewController.swift
//  QuickHealthPatient
//
//  Created by SS114 on 06/02/18.
//  Copyright © 2018 SL161. All rights reserved.
//

import UIKit

class TrackViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var noRecordLabel: UILabel!
    @IBOutlet var historyCell: UITableViewCell!
   
    @IBOutlet var nurseBtn: UIButton!
    @IBOutlet var medicineBtn: UIButton!
    @IBOutlet var lineImage: UIImageView!
  
    var dataArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        nurseListingWebservce()
        nurseBtn.setTitleColor(CommonValidations.UIColorFromRGB(rgbValue: 0x008080), for: .normal)
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
    
    
    //    MARK: - TableView Delegates
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        Bundle.main.loadNibNamed("trackCells", owner: self, options: nil)
        
        var cell:UITableViewCell!
        
        cell = tableView.dequeueReusableCell(withIdentifier: "historyCell")
        if cell == nil
        {
            cell = historyCell
            historyCell = nil
        }
        
        let profileImage = cell.viewWithTag(1) as! UIImageView
        let nameLabel = cell.viewWithTag(2) as! UILabel
        // let heartButton = cell.viewWithTag(3) as! UIButton
        let transactionLabel = cell.viewWithTag(4) as! UILabel
        //   let transactionDateImage = cell.viewWithTag(5) as! UIImageView
        let transactionDateLabel = cell.viewWithTag(6) as! UILabel
        // let transactionTimeImage = cell.viewWithTag(7) as! UIImageView
        let transactionTimeLabel = cell.viewWithTag(8) as! UILabel
        let physicianLabel = cell.viewWithTag(9) as! UILabel
        //  let acceptLabel = cell.viewWithTag(10) as! UILabel
        let trackButton = cell.viewWithTag(11) as! UIButton
        
        profileImage.image = #imageLiteral(resourceName: "profile")
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.layer.borderWidth = 2.0
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        
        if(dataArray.count > 0)
        {
            if let dic = ((dataArray.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "nurse_details") as? NSDictionary)
            {
                profileImage.setImageWith(URL(string: "\(dic.value(forKey: "user_image")!)")!, placeholderImage: #imageLiteral(resourceName: "profile"))
                nameLabel.text = "\(dic.value(forKey: "first_name")!) \(dic.value(forKey: "last_name")!)"
                transactionLabel.text = "ID-\(dic.value(forKey: "unique_number")!)"
                transactionDateLabel.text = CommonValidations.getDateStringFromDateString(date: "\((dic.value(forKey: "nurse_location") as! NSDictionary).value(forKey: "updated_on")!)", fromDateString: "yyyy-MM-dd HH:mm:ss", toDateString: "dd MMM yyyy")
                transactionTimeLabel.text = CommonValidations.getDateStringFromDateString(date: "\((dic.value(forKey: "nurse_location") as! NSDictionary).value(forKey: "updated_on")!)", fromDateString: "yyyy-MM-dd HH:mm:ss", toDateString: "hh:mm a")
                physicianLabel.text = "\(dic.value(forKey: "occupation")!)"
            }
        }
        
        
        trackButton.layer.cornerRadius = 4.0
        trackButton.layer.borderColor = CommonValidations.UIColorFromRGB(rgbValue: 0x008080).cgColor
        trackButton.layer.borderWidth = 1.0
        cell.selectionStyle = .none
        return cell
    }
    
    
    //MARK:- Action Method
    
    /// When user clicks on the button - Side Menu will be opened.
    ///
    /// - Parameter sender: UIButton
    @IBAction func sideMenutapped(_ sender: UIButton) {
        
    }
    
    /// When user clicks on the button - Pop back to screen.
    ///
    /// - Parameter sender: UIButton
    @IBAction func backButtontapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /// When user clicks on the button - doctor is selected as favourite.
    ///
    /// - Parameter sender: UIButton
    @IBAction func favButtontapped(_ sender: UIButton) {
        
        if sender.isSelected == true
        {
            sender.isSelected = false
        }
        else
        {
            sender.isSelected = true
        }
    }
    
    @IBAction func nurseMedicineBtn(_ sender: UIButton) {
        
        if sender.tag == 1
        {
            nurseBtn.setTitleColor(CommonValidations.UIColorFromRGB(rgbValue: 0x008080), for: .normal)
            
            medicineBtn.setTitleColor(CommonValidations.UIColorFromRGB(rgbValue: 0xC5C5C5), for: .normal)
            
            //-----------------------------------------------------------------------------------
            
            // Animation for highlighted underline
            UIView.transition(with: lineImage, duration: 0.3, options: [], animations: {
                self.lineImage.frame.origin.x = self.nurseBtn.frame.origin.x
            }, completion: { _ in
                
            })
            
            nurseListingWebservce()
        }
        else{
            
            medicineBtn.setTitleColor(CommonValidations.UIColorFromRGB(rgbValue: 0x008080), for: .normal)
            
            nurseBtn.setTitleColor(CommonValidations.UIColorFromRGB(rgbValue: 0xC5C5C5), for: .normal)
            
            //-----------------------------------------------------------------------------------
            
            // Animation for highlighted underline
            UIView.transition(with: lineImage, duration: 0.3, options: [], animations: {
                self.lineImage.frame.origin.x = self.medicineBtn.frame.origin.x
            }, completion: { _ in
                
            })
            
            medicineListingWebservice()
        }
    }
    
    @IBAction func trackBtnTapped(_ sender: UIButton) {
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView?.indexPathForRow(at: pointInTable)
        
        let vc = UIStoryboard(name: "TabbarStoryboard", bundle: nil).instantiateViewController(withIdentifier: "NurseTrackViewController") as! NurseTrackViewController
        
        vc.dataDic = (dataArray.object(at: (cellIndexPath?.row)!) as? NSDictionary)?.mutableCopy() as! NSMutableDictionary
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func medicineListingWebservice()
    {
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        self.noRecordLabel.isHidden = true
        let dict = NSMutableDictionary()
        dict.setObject(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "id_user" as NSCopying)
        dict.setObject("patient", forKey: "user_type" as NSCopying)
        //      dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPI(WebAPI.Nurse_Track_Listing, dict, { (operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    for i in 0..<(dataFromServer.value(forKey: "data") as! NSArray).count
                    {
                        if(((dataFromServer.value(forKey: "data") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "nurse_details") != nil)
                        {
                            self.dataArray.add(((dataFromServer.value(forKey: "data") as! NSArray).object(at: i) as! NSDictionary))
                        }
                    }
                    
                    if(self.dataArray.count == 0)
                    {
                        self.noRecordLabel.isHidden = false
                    }
                    self.tableView.reloadData()
                }
                else if(dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
                }
                else
                {
                    if dataFromServer.object(forKey: "message") != nil
                    {
                        // supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
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
    
    
    func nurseListingWebservce()
    {
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        self.noRecordLabel.isHidden = true
        let dict = NSMutableDictionary()
        dict.setObject(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "id_user" as NSCopying)
        dict.setObject("patient", forKey: "user_type" as NSCopying)
        //      dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPI(WebAPI.Nurse_Track_Listing, dict, { (operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    for i in 0..<(dataFromServer.value(forKey: "data") as! NSArray).count
                    {
                        if(((dataFromServer.value(forKey: "data") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "nurse_details") != nil)
                        {
                            self.dataArray.add(((dataFromServer.value(forKey: "data") as! NSArray).object(at: i) as! NSDictionary))
                        }
                    }
                    
                    if(self.dataArray.count == 0)
                    {
                        self.noRecordLabel.isHidden = false
                    }
                    self.tableView.reloadData()
                }
                else if(dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
                }
                else
                {
                    if dataFromServer.object(forKey: "message") != nil
                    {
                        // supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
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
