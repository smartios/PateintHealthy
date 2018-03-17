//
//  AvailabilityViewController.swift
//  DAWProvider
//
//  Created by SS142 on 22/02/17.
//
//

import UIKit

class AvailableDoctorsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var seeAll: UIButton!
    @IBOutlet var noRecordLbl: UILabel!
    @IBOutlet var heading: UILabel!
    var page = 0
    var ApptSend_serviceID = ""
    var requet_All_DocList = ""
    var dataArray = NSMutableArray()
    var screenSize = UIScreen.main.bounds.size
    var commingFromView = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        borderShadow()
        attributedButton()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.dataArray.removeAllObjects()
        page = 0
        self.tableView.reloadData()
        
        if commingFromView == "fromUserScreenvc"
        {
            heading.text = "FAVORITE DOCTORS"
            favouriteListWebService()
            
        }else
        {
            heading.text = "AVAILABLE DOCTORS"
            doctorListWebService()
        }
        
    }
    
    // MARK: - To make shadow at bottom view
    
    func borderShadow()
    {
        headerView.layer.masksToBounds = false
        headerView.layer.shadowColor = UIColor.gray.cgColor
        headerView.layer.shadowOffset = CGSize.zero
        headerView.layer.shadowOpacity = 0.5
        headerView.layer.shadowRadius = 1.0
        headerView.layer.shadowPath = UIBezierPath(rect:CGRect(x: 0, y: 63, width: screenSize.width, height: 1)).cgPath
    }
    
    //MARK: -  Make button text attributed
    func attributedButton()
    {
        
        let attrs = [
            NSFontAttributeName as NSString : UIFont(name: "OpenSans", size: 14.0) as Any,
            NSForegroundColorAttributeName as NSString : CommonValidations.UIColorFromRGB(rgbValue: 0x008080),
            NSUnderlineStyleAttributeName as NSString : 1] as [NSAttributedStringKey : Any]
        
        let attributedString = NSMutableAttributedString(string:"")
        
        let buttonTitleStr = NSMutableAttributedString(string:"See All", attributes:attrs as [String : Any])
        attributedString.append(buttonTitleStr)
        seeAll.setAttributedTitle(attributedString, for: .normal)
    }
    
    //    MARK: - TableView Delegates
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        
        cell = tableView.dequeueReusableCell(withIdentifier: "doctorListCell")
        
        let profileImage = cell.viewWithTag(1) as! UIImageView
        let name = cell.viewWithTag(2) as! UILabel
        let idNumber = cell.viewWithTag(3) as! UILabel
        let detailButton = cell.viewWithTag(4) as! UIButton
        
        detailButton.layer.borderWidth = 1.0
        detailButton.layer.cornerRadius = 5.0
        detailButton.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0).cgColor
        // ‎0, 128, 128
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.layer.borderWidth = 2.0
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        
        let dict = dataArray.object(at: indexPath.row) as! NSDictionary
        
        if dict.object(forKey: "user_image") != nil && dict.object(forKey: "user_image") is NSString && dict.object(forKey: "user_image") as! String != ""
        {
            profileImage.setImageWith(URL(string: dict.object(forKey: "user_image") as! String)!)
        }
        
        name.text = dict.object(forKey: "first_name") != nil && dict.object(forKey: "last_name") != nil && dict.object(forKey: "first_name") is NSString && dict.object(forKey: "last_name") is NSString ? "\(dict.object(forKey: "first_name")!) \(dict.object(forKey: "last_name")!)" : ""
        
        idNumber.text = dict.object(forKey: "unique_number") != nil && dict.object(forKey: "unique_number") is NSString ? "ID- \(dict.object(forKey: "unique_number")!)" : ""
        
//        if commingFromView != "fromUserScreenvc"
//        {
//            if indexPath.row == self.dataArray.count - 1
//            {
//                if (self.dataArray.count)%10 == 0
//                {
//                    page = (self.dataArray.count)/10 - 1
//                    page = page + 1
//                    self.doctorListWebService()
//                }
//            }
//        }    
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  let x = ((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id_user") as? String)
        {
          //  let idToSend = x
            
            if(requet_All_DocList != "all_doctor")
            {
                goToDoctorAvailScreen(x: x)
            }
            else
            {
                 let alert = UIAlertController(title: "", message: "Select Service", preferredStyle: .actionSheet)
              
                for i in 0..<((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "service_array") as! NSArray).count
                {
                    let title = "\((((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "service_array") as? NSArray)?.object(at: i) as! NSDictionary).value(forKey: "service_title")!)"
                 //service_title
                    //id
                    let action = UIAlertAction(title: title, style: .default, handler: { (alertAction) in
                        self.ApptSend_serviceID = alertAction.accessibilityHint!
                       self.goToDoctorAvailScreen(x: x)
                    })
                    action.accessibilityHint = "\((((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "service_array") as? NSArray)?.object(at: i) as! NSDictionary).value(forKey: "id")!)"
                    alert.addAction(action)
                }
                
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            }
            
      //      month_availability_ios(Index: idToSend)
        }
    }
    
    
    
    
    func goToDoctorAvailScreen(x: String)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AvailabilityViewController") as! AvailabilityViewController
        //vc.allBookedDateArray = (dataFromServer.object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
        vc.ApptSend_serviceID = self.ApptSend_serviceID
        vc.ApptSend_doctorsID = x
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Action Method
    
    /// When user clicks on seeAll button.
    ///
    /// - Parameter sender: UIButton
    @IBAction func seeAllBtnPressed(_ sender: UIButton)
    {
        self.dataArray.removeAllObjects()
        page = 0
        heading.text = "AVAILABLE DOCTORS"
        requet_All_DocList = "all_doctor"
        doctorListWebService()
    }
    
    /// When back button pressed - To pop back to previous screen.
    ///
    /// - Parameter sender: UIButton
    @IBAction func backBtnPressed(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// When detail button pressed - To get all data from the screen.
    ///
    /// - Parameter sender: UIButton
    @IBAction func detailBtnPressed(_ sender: UIButton)
    {
        //DoctorsProfileViewController
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView?.indexPathForRow(at: pointInTable)
        print(cellIndexPath!)
        
        let vc = UIStoryboard(name: "TabbarStoryboard", bundle: nil).instantiateViewController(withIdentifier: "DoctorsProfileViewController") as! DoctorsProfileViewController
        vc.docId = ((dataArray.object(at: cellIndexPath![1]) as! NSDictionary).object(forKey: "id_user") as! String)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - Webservice Method
    
    
   // func month_availability_ios(Index: String)
//    {
//        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
//
//        let apiSniper = APISniper()
//        let params = NSMutableDictionary()
//        let dateformatter = DateFormatter()
//        dateformatter.dateFormat = "dd-MM-yyyy"
//
//        let now = dateformatter.string(from: NSDate() as Date)
//        print(now)
//        params.setObject(Index, forKey: "doctor_id" as NSCopying)
//        params.setObject(now, forKey: "date" as NSCopying)
//        params.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
//
//        apiSniper.getDataFromWebAPI(WebAPI.month_availability_ios, params ,{(operation, responseObject) in
//
//            if let dataFromServer = responseObject as? NSDictionary
//            {
//                print(dataFromServer)
//                supportingfuction.hideProgressHudInView(view: self)
//                //status
//                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
//                {
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AvailabilityViewController") as! AvailabilityViewController
//                    vc.allBookedDateArray = (dataFromServer.object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
//                    vc.ApptSend_serviceID = self.ApptSend_serviceID
//                    vc.ApptSend_doctorsID = Index
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//                else if(dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
//                {
//                    logoutUser()
//                }
//                else
//                {
//                    supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
//                }
//
//            }
//        }) { (operation, error) in
//            supportingfuction.hideProgressHudInView(view: self)
//            print(error.localizedDescription)
//
//            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
//        }
//    }
    
    
    func doctorListWebService()
    {
        self.noRecordLbl.isHidden = true
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        let apiSniper = APISniper()
        
        let params = NSMutableDictionary()
        
        if requet_All_DocList != ""
        {
            params.setObject(requet_All_DocList, forKey: "service_id" as NSCopying)
        }else
        {
            params.setObject(ApptSend_serviceID, forKey: "service_id" as NSCopying)
        }
       // params.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        params.setObject(page, forKey: "page" as NSCopying)
        
        apiSniper.getDataFromWebAPI(WebAPI.doctor_list, params ,{(operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    if (dataFromServer.object(forKey: "data") as! NSArray).count > 0
                    {
                        self.dataArray.addObjects(from: ((dataFromServer.object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray) as! [Any])
                        self.tableView.reloadData()
                    }else
                    {
                        if self.dataArray.count == 0
                        {
                            self.noRecordLbl.isHidden = false
                        }
                    }
                }
                else if(dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    
                    logoutUser()
                }
                else
                {
                    if self.dataArray.count == 0
                    {
                        self.noRecordLbl.isHidden = false
                    }
                }
            }
        }) { (operation, error) in
            supportingfuction.hideProgressHudInView(view: self)
            print(error.localizedDescription)
            
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        }
    }
    
    
    func favouriteListWebService()
    {
        self.noRecordLbl.isHidden = true
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        let apiSniper = APISniper()
        
        let params = NSMutableDictionary()
        params.setObject(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "id_user" as NSCopying)
        params.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        
        apiSniper.getDataFromWebAPI(WebAPI.favourite_list, params ,{(operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    if (dataFromServer.object(forKey: "data") as! NSArray).count > 0
                    {
                        self.dataArray = (dataFromServer.object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
                        self.tableView.reloadData()
                    }else
                    {
                        //supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                        self.noRecordLbl.isHidden = false
                    }
                }
                else if(dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
                }
                else
                {
                    //supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                    self.noRecordLbl.isHidden = false
                }
            }
        }) { (operation, error) in
            supportingfuction.hideProgressHudInView(view: self)
            print(error.localizedDescription)
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        }
    }
}
