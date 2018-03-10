//
//  SelectPatientViewController.swift
//  QuickHealthPatient
//
//  Created by mac  on 12/01/18.
//  Copyright © 2018 SL161. All rights reserved.
//

import UIKit

class SelectPatientViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var childView: UIView!
     @IBOutlet weak var firstName: UITextField!
     @IBOutlet weak var lastName: UITextField!
     @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var maleRadioBtn: UIButton!
    @IBOutlet weak var femaleRadioBtn: UIButton!
    
    @IBOutlet weak var someOneElsePopup: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    var childListArray = NSMutableArray()
    var addChildDict = NSMutableDictionary()
    @IBOutlet weak var saveBtnOutlet: UIButton!
    @IBOutlet weak var okBtnOutlet: UIButton!
    
   
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
   
    var ApptSend_slotIDtoSend = ""
    var ApptSend_serviceID = ""
    var ApptSend_doctorsID = ""
   
    
    var childOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
         saveBtnOutlet.layer.cornerRadius = 5.0
        okBtnOutlet.layer.cornerRadius = 5.0
        saveBtnOutlet.clipsToBounds = true
        okBtnOutlet.clipsToBounds = true
        
        firstName.placeholder = "First Name"
        lastName.placeholder = "Last Name"
        dob.placeholder = "Date Of Birth"
        
        datePickerView.isHidden = true
        datePickerView.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        popupView.addGestureRecognizer(tap)
        childView.layer.cornerRadius = 10
        someOneElsePopup.layer.cornerRadius = 10
        someOneElsePopup.layer.masksToBounds = false
        childView.layer.masksToBounds = false
       
        popupView.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        popupView.isHidden = true
        getChildList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleTap() {
        // handling code
        self.view.endEditing(true)
        popupView.isHidden = true
    }
    
    @IBAction func Some1ElseokayBtn(_ sender: Any) {
//        UserScreenViewController().logoutUser()
        
        popupView.isHidden = true
        childView.isHidden = true
        someOneElsePopup.isHidden = true
    }
    // MARK: - tableview delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
       return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 1
        }else if section == 1
        {
            if childOpen == true
            {
              return childListArray.count + 2
            }
            
            else
            {
                return 1
            }
            
        }else
        {
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if indexPath.section == 0
        {
            // me section
           
            cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
            let lbl = cell.viewWithTag(1) as! UILabel
            let arrowBtn = cell.viewWithTag(2) as! UIButton
            arrowBtn.isSelected = false
            lbl.textColor = UIColor.darkGray
            lbl.text = "MYSELF"
        }else if indexPath.section == 1
        {
            //child section
            
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
                let lbl = cell.viewWithTag(1) as! UILabel
                let arrowBtn = cell.viewWithTag(2) as! UIButton
                lbl.textColor = UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
                lbl.text = "MY CHILD"
                if childOpen == true
                {
                    arrowBtn.isSelected = true
                }else
                {
                    arrowBtn.isSelected = false
                    
                }
                
            }
            else if indexPath.row == childListArray.count + 1
            {
//
                 cell = tableView.dequeueReusableCell(withIdentifier: "AddchildCell")
                let lbl = cell.viewWithTag(1) as! UILabel
                lbl.textColor = UIColor(red: 161.0 / 255.0, green: 161.0 / 255.0, blue: 161.0 / 255.0, alpha: 1.0)
               // lbl.text = "MY CHILD"
            }
            
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "childCell")
                let lbl = cell.viewWithTag(1) as! UILabel
                lbl.textColor = UIColor.darkGray
                if childListArray.count > 0
                {
                    if let x = (childListArray.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "first_name") as? String, let y = (childListArray.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "last_name") as? String
                    {
                        lbl.text = x + " " + y
                    }else
                    {
                       lbl.text = "N/A"
                    }
                }
                
               
            }
           
        }else
        {
            //someone else row tapped
            cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
            let lbl = cell.viewWithTag(1) as! UILabel
            let arrowBtn = cell.viewWithTag(2) as! UIButton
            arrowBtn.isSelected = false
            lbl.textColor = UIColor.darkGray
            lbl.text = "SOMEONE ELSE"
            
        }
       
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0
        {
            // me section
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PresentConditionViewController") as! PresentConditionViewController
            vc.ApptSend_user_type = "myself"
            vc.ApptSend_slotIDtoSend = ApptSend_slotIDtoSend
            vc.ApptSend_serviceID = ApptSend_serviceID
            vc.ApptSend_doctorsID = ApptSend_doctorsID
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.section == 1
        {
            //child section
            if indexPath.row == 0
            {
                if childOpen == false
                {
                    childOpen = true
                }else
                {
                    childOpen = false
                }
                
                tableView.reloadData()
            }
            else if indexPath.row == childListArray.count + 1
            {
                addChildDict.setObject("Male", forKey: "gender" as NSCopying)
                maleRadioBtn.isSelected = true
                popupView.isHidden = false
                childView.isHidden = false
                someOneElsePopup.isHidden = true
                print("+ add child")
            }else
            {
                //PresentConditionViewController
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PresentConditionViewController") as! PresentConditionViewController
                vc.ApptSend_user_type = "child"
                vc.ApptSend_child_ID = (childListArray.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "id_child") as! String
                vc.ApptSend_slotIDtoSend = ApptSend_slotIDtoSend
                vc.ApptSend_serviceID = ApptSend_serviceID
                vc.ApptSend_doctorsID = ApptSend_doctorsID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else
        {
            //someone else row tapped
            popupView.isHidden = false
            childView.isHidden = true
            someOneElsePopup.isHidden = false
        }
    }
    
    @IBAction func genderBtnClicked(sender: UIButton)
    {
        if sender.tag == -2
        {
            addChildDict.setObject("Male", forKey: "gender" as NSCopying)
            maleRadioBtn.isSelected = true
            femaleRadioBtn.isSelected = false
        }else{
            addChildDict.setObject("Female", forKey: "gender" as NSCopying)
            maleRadioBtn.isSelected = false
            femaleRadioBtn.isSelected = true
        }
      
    }
    @IBAction func showDatePicker(_ sender: Any) {
         self.view.endEditing(true)
        datePickerView.isHidden = false
        self.view.endEditing(true)
    }
    @IBAction func selectedDate(sender: AnyObject)
    {
       
        setDateAndTime()
        datePickerView.isHidden = true
        
    }
    
    @IBAction func DateCancelBtn(sender: UIButton)
    {
        datePickerView.isHidden = true
    }
    func setDateAndTime()
    {
        datePicker.datePickerMode = UIDatePickerMode.date
        
        let date: DateFormatter = DateFormatter()
        
        //date.dateFormat = "dd-MM-YYYY"
        date.dateFormat = "dd-MMM-yyyy"
        
        let currDate = NSDate() as Date
        if currDate.compare(datePicker.date) == .orderedAscending
        {
            supportingfuction.showMessageHudWithMessage(message: invalidDate as NSString, delay: 2.0)
            return
        }
        else
        {
            addChildDict.setObject((date.string(from: datePicker.date) ), forKey: "date_of_birth" as NSCopying)
            
            if let x = addChildDict.object(forKey: "date_of_birth") as? String
            {
                 dob.text = x
            }
            if let x = addChildDict.object(forKey: "first_name") as? String
            {
                firstName.text = x
            }
            
            if let x = addChildDict.object(forKey: "last_name") as? String
            {
                lastName.text = x
            }
            
        }
        
    }
    // MARK: - BACKBTN TAPPED
    @IBAction func backBtnTapper(sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == firstName
        {
            if textField.text != ""
            {
                addChildDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "first_name" as NSCopying)
            }else
            {
                addChildDict.setObject("", forKey: "first_name" as NSCopying)
            }
        }
         else if textField == lastName
        {
            if textField.text != ""
            {
              addChildDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "last_name" as NSCopying)
            }else
            {
                addChildDict.setObject("", forKey: "last_name" as NSCopying)
            }
            
        }
        if let x = addChildDict.object(forKey: "first_name") as? String
        {
            firstName.text = x
        }
        
        if let x = addChildDict.object(forKey: "last_name") as? String
        {
             lastName.text = x
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    
    
   // add child web method
    @IBAction func saveBtn(sender: UIButton)
    {
       
        let dict = NSMutableDictionary()
        
        if let x = addChildDict.object(forKey: "first_name") as? String
        {
            dict.setObject(x, forKey: "first_name" as NSCopying)
        }else
        {
            supportingfuction.showMessageHudWithMessage(message: enterFirstName as NSString, delay: 2.0)
            return
            
        }
        
        if let x = addChildDict.object(forKey: "last_name") as? String
        {
            dict.setObject(x, forKey: "last_name" as NSCopying)
        }else
        {
            supportingfuction.showMessageHudWithMessage(message: enterLastName as NSString, delay: 2.0)
            return
            
        }
        
        if let x = addChildDict.object(forKey: "date_of_birth") as? String
        {
            dict.setObject(x, forKey: "date_of_birth" as NSCopying)
        }else
        {
            supportingfuction.showMessageHudWithMessage(message: enterDob as NSString, delay: 2.0)
            return
        }
        
        
        if let x = addChildDict.object(forKey: "gender") as? String
        {
            dict.setObject(x, forKey: "gender" as NSCopying)
        }else
        {
            supportingfuction.showMessageHudWithMessage(message: gender as NSString, delay: 2.0)
            return
            
            
        }
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        dict.setObject(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id" as NSCopying)
        let apiSniper = APISniper()
         supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        apiSniper.getDataFromWebAPI(WebAPI.add_child,dict, {(operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    if dataFromServer.object(forKey: "message") != nil
                    {
                        // supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                        
                        if (dataFromServer.object(forKey: "data") as! NSArray).count > 0
                        {
                            self.childListArray = ((dataFromServer).object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
                            self.tableView.reloadData()
                             self.popupView.isHidden = true
                            
                            self.firstName.placeholder = ""
                            self.lastName.placeholder = ""
                            self.dob.placeholder = ""
                            
                        }
                    }
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
    
    
    func getChildList()
    {
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        let apiSniper = APISniper()
        
        let params = NSMutableDictionary()
        params.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        params.setObject(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id" as NSCopying)
        
        apiSniper.getDataFromWebAPI(WebAPI.child_list, params ,{(operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    if (dataFromServer.object(forKey: "data") as! NSArray).count > 0
                    {
                     self.childListArray = ((dataFromServer).object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
                      self.tableView.reloadData()
                    }
//
                }
                else if(dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    
                    logoutUser()
                }
                else
                {
                    supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                }
            }
        }) { (operation, error) in
            supportingfuction.hideProgressHudInView(view: self)
            print(error.localizedDescription)
            
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
