//
//  AppointmentListViewController.swift
//  QuickHealthPatient
//
//  Created by mac  on 19/01/18.
//  Copyright © 2018 SL161. All rights reserved.
//

import UIKit

class AppointmentListViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource,fechedchildList {
    
    @IBOutlet var noRecordLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var todayApptArray = NSMutableArray()
    var upcommingApptArray = NSMutableArray()
    var filterKey = ""
    var child_Id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.tableFooterView = UIView()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = .white
        if(!appDelegate.hasConnectivity())
        {
            supportingfuction.showMessageHudWithMessage(message: NoInternetConnection as NSString, delay: 2.0)
        }
        else
        {
            if(UserDefaults.standard.value(forKey: "user_detail") != nil)
            {
            appointment_list()
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - tableView Delegate Methods
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            if todayApptArray.count > 0
            {
                return 50.0
            }
            return 0
        }
        else
        {
            if upcommingApptArray.count > 0
            {
                return 50.0
            }
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 15.0))
        let label = UILabel(frame: CGRect(x: 16.0, y: 0.0, width: UIScreen.main.bounds.size.width - 32.0, height: 50.0))
        view.backgroundColor =  UIColor(red: 248.0 / 255.0, green: 248.0 / 255.0, blue: 248.0 / 255.0, alpha: 1)
        label.textColor = UIColor.lightGray
        label.font = UIFont(name: "OpenSans-Bold", size: 14.0)
        label.textAlignment = .left
        label.backgroundColor = UIColor.clear
        if section == 0
        {
            label.text = "TODAY'S APPOINTMENT"
        }
        else
        {
            label.text = "UPCOMING APPOINTMENT"
        }
        view.addSubview(label)
        return view
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return todayApptArray.count
        }else
        {
            return upcommingApptArray.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        if indexPath.section == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "profileCell")
            let patientImg = cell.viewWithTag(1) as! UIImageView
            let patientName = cell.viewWithTag(2) as! UILabel
            let patientId = cell.viewWithTag(3) as! UILabel
            let patientDate = cell.viewWithTag(4) as! UILabel
            let patientTime = cell.viewWithTag(5) as! UILabel
            let patientType = cell.viewWithTag(6) as! UILabel
            let patientDbutton = cell.viewWithTag(7) as! UIButton
            let joinCall = cell.viewWithTag(8) as! UIButton
            
            if (todayApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "join_call") != nil && "\((todayApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "join_call")!)" == "true"
            {
                joinCall.isHidden = false
            }
            else
            {
                joinCall.isHidden = true
            }
            
            if (((todayApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "doctor_detail") as! NSDictionary).object(forKey: "user_image") as? String) != nil
            {
                patientImg.setImageWith(NSURL(string: (((todayApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "doctor_detail") as! NSDictionary).object(forKey: "user_image") as! String))! as URL, placeholderImage: UIImage(named: "landing_image"))
            }
            
            if (((todayApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "doctor_detail") as! NSDictionary).object(forKey: "first_name") as? String) != nil
            {
                patientName.text = (((todayApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "doctor_detail") as! NSDictionary).object(forKey: "first_name") as! String) + " " + (((todayApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "doctor_detail") as! NSDictionary).object(forKey: "last_name") as! String)
            }
            
            if (((todayApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "doctor_detail") as! NSDictionary).object(forKey: "unique_number") as? String) != nil
            {
                patientId.text = "ID-\(((todayApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "doctor_detail") as! NSDictionary).object(forKey: "unique_number") as! String)"
            }
            
            if ((todayApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "available_date") as? String) != nil
            {
                let mathString: String = (((todayApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "available_date") as! String))
                let numbers = mathString.components(separatedBy: [" "])
                
                patientDate.text = CommonValidations.getDateUTCStringFromDateString(date: "\(numbers[0])", fromDateString: "YYYY-MM-dd", toDateString: "dd MMM, YYYY")
            }
            
            if ((todayApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "start_time") as? String) != nil
            {
                patientTime.text =  CommonValidations.getDateUTCStringFromDateString(date: "\((todayApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "start_time")!)", fromDateString: "HH:mm:ss", toDateString: "hh:mm a")
            }
            
            if (((todayApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "doctor_detail") as! NSDictionary).object(forKey: "service_title") as? String) != nil
            {
                patientType.text = (((todayApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "doctor_detail") as! NSDictionary).object(forKey: "service_title") as! String)
            }
            
            joinCall.layer.cornerRadius = 3.0
            joinCall.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 0.75).cgColor
            joinCall.layer.borderWidth = 1
            patientDbutton.layer.cornerRadius = 3.0
            patientDbutton.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 0.75).cgColor
            patientDbutton.layer.borderWidth = 1
            patientImg.layer.cornerRadius = patientImg.frame.width/2
            patientImg.clipsToBounds = true
            patientImg.layer.borderWidth = 1
            patientImg.layer.borderColor = UIColor.lightGray.cgColor
            cell.backgroundColor = UIColor.clear
        }else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "profileCell")
            let patientImg = cell.viewWithTag(1) as! UIImageView
            let patientName = cell.viewWithTag(2) as! UILabel
            let patientId = cell.viewWithTag(3) as! UILabel
            let patientDate = cell.viewWithTag(4) as! UILabel
            let patientTime = cell.viewWithTag(5) as! UILabel
            let patientType = cell.viewWithTag(6) as! UILabel
            let patientDbutton = cell.viewWithTag(7) as! UIButton
            let joinCall = cell.viewWithTag(8) as! UIButton
            joinCall.isHidden = true
           
            
            if (((upcommingApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "doctor_detail") as! NSDictionary).object(forKey: "user_image") as? String) != nil
            {
                patientImg.setImageWith(NSURL(string: (((upcommingApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "doctor_detail") as! NSDictionary).object(forKey: "user_image") as! String))! as URL, placeholderImage: UIImage(named: "landing_image"))
            }
            
            if (((upcommingApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "doctor_detail") as! NSDictionary).object(forKey: "first_name") as? String) != nil
            {
                patientName.text = (((upcommingApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "doctor_detail") as! NSDictionary).object(forKey: "first_name") as! String) + " " + (((upcommingApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "doctor_detail") as! NSDictionary).object(forKey: "last_name") as! String)
            }
            
            if (((upcommingApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "doctor_detail") as! NSDictionary).object(forKey: "unique_number") as? String) != nil
            {
                patientId.text = "ID-\(((upcommingApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "doctor_detail") as! NSDictionary).object(forKey: "unique_number") as! String)"
            }
            
            if ((upcommingApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "available_date") as? String) != nil
            {
                let mathString: String = (((upcommingApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "available_date") as! String))
                let numbers = mathString.components(separatedBy: [" "])
                
                patientDate.text = CommonValidations.getDateUTCStringFromDateString(date: "\(numbers[0])", fromDateString: "YYYY-MM-dd", toDateString: "dd MMM, YYYY")
            }
            
            if ((upcommingApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "start_time") as? String) != nil
            {
                patientTime.text =  CommonValidations.getDateUTCStringFromDateString(date: "\(((upcommingApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "start_time") as! String))", fromDateString: "HH:mm:SS", toDateString: "hh:mm a")
            }
            
            if (((upcommingApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "doctor_detail") as! NSDictionary).object(forKey: "service_title") as? String) != nil
            {
                patientType.text = (((upcommingApptArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "doctor_detail") as! NSDictionary).object(forKey: "service_title") as! String)
            }
            
            joinCall.layer.cornerRadius = 3.0
            joinCall.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 0.75).cgColor
            joinCall.layer.borderWidth = 1
            patientDbutton.layer.cornerRadius = 3.0
            patientDbutton.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 0.75).cgColor
            patientDbutton.layer.borderWidth = 1
            patientImg.layer.cornerRadius = patientImg.frame.width/2
            patientImg.clipsToBounds = true
            patientImg.layer.borderWidth = 1
            patientImg.layer.borderColor = UIColor.lightGray.cgColor
            cell.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    // MARK: - BackBtn Tapped
    
    
    @IBAction func menuButtonClicked(sender: AnyObject) {
        onSlideMenuButtonPressed(sender as! UIButton)
    }
    
    
    func appointment_list()
    {
        supportingfuction.hideProgressHudInView(view: self)
        self.noRecordLbl.isHidden = true
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        
        dict.setObject(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id" as NSCopying)
        dict.setObject("patient", forKey: "account_type" as NSCopying)
        
        dict.setObject(filterKey, forKey: "filter_key" as NSCopying)
        dict.setObject(child_Id, forKey: "child_id" as NSCopying)
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPI(WebAPI.appointment_list,dict, {(operation, responseObject) in
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    
                    if let x = ((dataFromServer.object(forKey: "data") as! NSDictionary).object(forKey: "todays_appointments") as? NSArray)
                    {
                        self.todayApptArray = x.mutableCopy() as! NSMutableArray
                    }
                    
                    if let x = ((dataFromServer.object(forKey: "data") as! NSDictionary).object(forKey: "upcoming_appointments") as? NSArray)
                    {
                        self.upcommingApptArray = x.mutableCopy() as! NSMutableArray
                    }
                    
                    self.tableView?.reloadData()
                    
                    if self.todayApptArray.count == 0 && self.upcommingApptArray.count == 0
                    {
                        // supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                        self.noRecordLbl.isHidden = false
                    }
                }
                else if(dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
                }
                else
                {
                    if dataFromServer.object(forKey: "message") != nil && self.todayApptArray.count == 0 && self.upcommingApptArray.count == 0
                    {
                        //  supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
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
    
    func getChildId(code: String, ID: String) {
        
        if code == "Myself"
        {
            filterKey = "Myself"
            child_Id = "0"
        }
        else if code == "All"
        {
            child_Id = "All"
            filterKey = "All"
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
            appointment_list()
            
        }
    }
    
    @IBAction func joinCall(_ sender: Any)
    {
        let pointInTable: CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView?.indexPathForRow(at: pointInTable)
        let dic = (todayApptArray.object(at: (cellIndexPath?.row)!) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
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
        vc.dataDic.setValue(dic.value(forKey: "doctor_detail") as! NSDictionary, forKey: "user_detail")
        vc.dataDic.setValue("\((dic.value(forKey: "doctor_detail") as! NSDictionary).value(forKey: "id_user")!)", forKey: "id_doctor")
         vc.dataDic.setValue("\((dic.value(forKey: "id_appointment"))!)", forKey: "id_appointment")
        vc.from = "join"
        
        UserDefaults.standard.setValue("\(dic.value(forKey: "id_appointment")!)", forKey: "ongoing_id_appointment")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func filterBtnTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChildListViewController") as! ChildListViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func detailsBtnTapped(_ sender: Any) {
        
        let pointInTable: CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView?.indexPathForRow(at: pointInTable)
        print(cellIndexPath![1])
        
        if cellIndexPath![0] == 0
        {
            if let x = ((todayApptArray.object(at: (cellIndexPath![1])) as! NSDictionary).object(forKey: "id_appointment") as? String)
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentDeatilsView") as! AppointmentDeatilsView
                vc.appt_id = x
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else
        {
            if let x = ((upcommingApptArray.object(at: (cellIndexPath![1])) as! NSDictionary).object(forKey: "id_appointment") as? String)
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentDeatilsView") as! AppointmentDeatilsView
                vc.appt_id = x
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
