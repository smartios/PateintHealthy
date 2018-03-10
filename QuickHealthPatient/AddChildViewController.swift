//
//  AddChildViewController.swift
//  QuickHealthPatient
//
//  Created by mac  on 18/12/17.
//  Copyright © 2017 SL161. All rights reserved.
//

import UIKit
protocol childList {
    func getChildArray(childArray: NSMutableArray)
}
class AddChildViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView?
    var dataDict = NSMutableDictionary()
    
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var delegate:childList!
    override func viewDidLoad() {
        super.viewDidLoad()
 dataDict.setObject("Male", forKey: "gender" as NSCopying)
        
        datePickerView.isHidden = true
        datePickerView.isHidden = true
        datePicker.datePickerMode = UIDatePickerMode.date
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - TableView delegate 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if indexPath.row == 0
        {
           cell = tableView.dequeueReusableCell(withIdentifier: "editCell")
           let titleLbl = cell.viewWithTag(1) as! UILabel
           let textFiled = cell.viewWithTag(2) as! UITextField
           titleLbl.text = "FIRST NAME"
            textFiled.placeholder = "FIRST NAME"
            textFiled.isSecureTextEntry = false
            textFiled.isUserInteractionEnabled = true
            textFiled.keyboardType = UIKeyboardType.asciiCapable
            textFiled.autocapitalizationType = UITextAutocapitalizationType.sentences
            if let x = dataDict.object(forKey: "first_name") as? String
            {
               textFiled.text = x
            }
           
             cell.backgroundColor = UIColor.clear
        }else if indexPath.row == 1
        {
             cell = tableView.dequeueReusableCell(withIdentifier: "editCell")
            let titleLbl = cell.viewWithTag(1) as! UILabel
             let textFiled = cell.viewWithTag(2) as! UITextField
            titleLbl.text = "LAST NAME"
            textFiled.placeholder = "LAST NAME"
            textFiled.isSecureTextEntry = false
            textFiled.isUserInteractionEnabled = true
            textFiled.keyboardType = UIKeyboardType.asciiCapable
            textFiled.autocapitalizationType = UITextAutocapitalizationType.sentences
            if let x = dataDict.object(forKey: "last_name") as? String
            {
                textFiled.text = x
            }
             cell.backgroundColor = UIColor.clear
        }else if indexPath.row == 2
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "editCell")
            let titleLbl = cell.viewWithTag(1) as! UILabel
             let textFiled = cell.viewWithTag(2) as! UITextField
            textFiled.isSecureTextEntry = false
            textFiled.isUserInteractionEnabled = false
            textFiled.keyboardType = UIKeyboardType.asciiCapable
            textFiled.autocapitalizationType = UITextAutocapitalizationType.sentences
            titleLbl.text = "DATE OF BIRTH"
            textFiled.placeholder = "DATE OF BIRTH"
            if let x = dataDict.object(forKey: "date_of_birth") as? String
            {
               textFiled.text = x
            }
           
             cell.backgroundColor = UIColor.clear
        }else if indexPath.row == 3
        {
           cell = tableView.dequeueReusableCell(withIdentifier: "genderCell")
            let titleLbl = cell.viewWithTag(1) as! UILabel
            let maleBTn = cell.viewWithTag(-2) as! UIButton
            let femaleBTn = cell.viewWithTag(-3) as! UIButton
            titleLbl.text = "GENDER"
            if dataDict.object(forKey: "gender") as! String == "Male"
            {
                maleBTn.isSelected = true
                femaleBTn.isSelected = false
            }else if dataDict.object(forKey: "gender") as! String == "Female"
            {
                maleBTn.isSelected = false
                femaleBTn.isSelected = true
            }else
            {
                maleBTn.isSelected = false
                femaleBTn.isSelected = false
            }
            
             cell.backgroundColor = UIColor.clear
        }else
        {
           cell = tableView.dequeueReusableCell(withIdentifier: "btnCell")
             cell.backgroundColor = UIColor.clear
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2
        {
            datePickerView.isHidden = false
            // datePicker.maximumDate = NSDate() as Date
            self.view.endEditing(true)
            return
        }
    }
    
     // MARK: - textfiled delegate 
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let pointInTable: CGPoint = textField.convert(textField.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView?.indexPathForRow(at: pointInTable)
        print(cellIndexPath!)
        
        if cellIndexPath![1] == 0
        {
            if textField.text != ""
            {
               dataDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "first_name" as NSCopying)
            }else
            {
              dataDict.setObject("", forKey: "first_name" as NSCopying)
            }
           
        }else if cellIndexPath![1] == 1
        {
            if textField.text != ""
            {
             dataDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "last_name" as NSCopying)
            }else
            {
              dataDict.setObject("", forKey: "last_name" as NSCopying)
            }
           
        }else if cellIndexPath![1] == 2
        {
            if textField.text != ""
            {
           dataDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "date_of_birth" as NSCopying)
            }else
            {
              dataDict.setObject("", forKey: "date_of_birth" as NSCopying)
            }
        }else if cellIndexPath![1] == 3
        {
            if textField.text != ""
            {
              dataDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "gender" as NSCopying)
            }else
            {
                 dataDict.setObject("", forKey: "gender" as NSCopying)
            }
          
        }
    }

    
    // MARK: - IBActions
    @IBAction func genderBtnClicked(sender: UIButton)
    {
        if sender.tag == -2
        {
            dataDict.setObject("Male", forKey: "gender" as NSCopying)
        }else{
            dataDict.setObject("Female", forKey: "gender" as NSCopying)
        }
        
//        reloadCell to change gender
        let indexPath = IndexPath(row: 3 , section: 0)
        self.tableView?.reloadRows(at: [indexPath], with: .automatic)
    }
    @IBAction func backBtn(sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - web method to save added child
    
    @IBAction func saveBtn(sender: UIButton)
    {
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        
        if let x = dataDict.object(forKey: "first_name") as? String
        {
          dict.setObject(x, forKey: "first_name" as NSCopying)
        }else
        {
            supportingfuction.showMessageHudWithMessage(message: enterFirstName as NSString, delay: 2.0)
            return
            
        }
        
        if let x = dataDict.object(forKey: "last_name") as? String
        {
           dict.setObject(x, forKey: "last_name" as NSCopying)
        }else
        {
            supportingfuction.showMessageHudWithMessage(message: enterLastName as NSString, delay: 2.0)
            return
          
        }
       
        if let x = dataDict.object(forKey: "date_of_birth") as? String
        {
          dict.setObject(x, forKey: "date_of_birth" as NSCopying)
        }else
        {
            supportingfuction.showMessageHudWithMessage(message: enterDob as NSString, delay: 2.0)
            return
                   }
        
        
        if let x = dataDict.object(forKey: "gender") as? String
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
                        
                        if let x = (dataFromServer ).mutableCopy() as? NSMutableDictionary
                        {
                            self.delegate.getChildArray(childArray: (x.object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray)
                        }
                        
                        
                        
                        _ = self.navigationController?.popViewController(animated: true)
                        
                     
                        
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
    
    
   // MARK: - setting the selected date in text field
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
            dataDict.setObject((date.string(from: datePicker.date) ), forKey: "date_of_birth" as NSCopying)
        }
        self.tableView?.reloadData()
    }
    
    //after tapped it will call
    @IBAction func selectedDate(sender: AnyObject)
    {
        setDateAndTime()
        
        datePickerView.isHidden = true
        
    }
    
    
    
    @IBAction func DateCancelBtn(sender: UIButton)
    {
        datePickerView.isHidden = true
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
