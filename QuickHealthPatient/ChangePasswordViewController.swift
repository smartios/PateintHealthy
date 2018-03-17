//
//  ChangePasswordViewController.swift
//  QuickHealthPatient
//
//  Created by mac  on 18/12/17.
//  Copyright © 2017 SL161. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView?
    var dataDict = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 4
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
                       let titleLbl = cell.viewWithTag(1) as! UILabel
            let textFiled = cell.viewWithTag(2) as! UITextField
            titleLbl.text = "CURRENT PASSWORD"
            textFiled.placeholder = "**********"
            textFiled.isSecureTextEntry = true
            textFiled.isUserInteractionEnabled = true
            textFiled.keyboardType = UIKeyboardType.asciiCapable
            textFiled.autocapitalizationType = UITextAutocapitalizationType.sentences
            if let x = dataDict.object(forKey: "old_password") as? String
            {
                textFiled.text = x
            }
        }else if indexPath.row == 1
        {
          cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
            
            let titleLbl = cell.viewWithTag(1) as! UILabel
            let textFiled = cell.viewWithTag(2) as! UITextField
            titleLbl.text = "NEW PASSWORD"
            textFiled.placeholder = "**********"
            textFiled.isSecureTextEntry = true
            textFiled.isUserInteractionEnabled = true
            textFiled.keyboardType = UIKeyboardType.asciiCapable
            textFiled.autocapitalizationType = UITextAutocapitalizationType.sentences
            if let x = dataDict.object(forKey: "new_password") as? String
            {
                textFiled.text = x
            }
        }else if indexPath.row == 2
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
           
            let titleLbl = cell.viewWithTag(1) as! UILabel
            let textFiled = cell.viewWithTag(2) as! UITextField
            titleLbl.text = "RE-TYPE PASSWORD"
            textFiled.placeholder = "**********"
            textFiled.isSecureTextEntry = true
            textFiled.isUserInteractionEnabled = true
            textFiled.keyboardType = UIKeyboardType.asciiCapable
            textFiled.autocapitalizationType = UITextAutocapitalizationType.sentences
            if let x = dataDict.object(forKey: "confirm_password") as? String
            {
                textFiled.text = x
            }
        }else if indexPath.row == 3
        {
           cell = tableView.dequeueReusableCell(withIdentifier: "btnCell")
        }
        
        return cell
    }
    
    // MARK: - textfield delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let pointInTable: CGPoint = textField.convert(textField.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView?.indexPathForRow(at: pointInTable)
        print(cellIndexPath!)
        
        if cellIndexPath![1] == 0
        {
            if textField.text != ""
            {
                dataDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "old_password" as NSCopying)
            }else
            {
                dataDict.setObject("", forKey: "old_password" as NSCopying)
            }
            
        }else if cellIndexPath![1] == 1
        {
            if textField.text != ""
            {
                dataDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "new_password" as NSCopying)
            }else
            {
                dataDict.setObject("", forKey: "new_password" as NSCopying)
            }
            
        }else if cellIndexPath![1] == 2
        {
            if textField.text != ""
            {
                dataDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "confirm_password" as NSCopying)
            }else
            {
                dataDict.setObject("", forKey: "confirm_password" as NSCopying)
            }
        }

    }
    
    @IBAction func backBtn(sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    // MARK: - change password webservice
    @IBAction func saveBtnClicked(sender: UIButton)
    {
        self.view.endEditing(true)
        let dict = NSMutableDictionary()
        
        if let x = dataDict.object(forKey: "old_password") as? String
        {
            dict.setObject(x, forKey: "old_password" as NSCopying)
        }else
        {
            supportingfuction.showMessageHudWithMessage(message: "Please enter Current Password." as NSString, delay: 2.0)
            return
            
        }
        
        if dataDict.object(forKey: "new_password") == nil ||
            dataDict.object(forKey: "new_password") as! String == ""
            
        {
            supportingfuction.showMessageHudWithMessage(message: "Please enter New Password." as NSString, delay: 2.0)
            return
            
        }else  if validationForPassword() == false
        {
            supportingfuction.showMessageHudWithMessage(message: validPassword as NSString, delay: 2.0)
            return
            
        }
        if let x = dataDict.object(forKey: "new_password") as? String
        {
            dict.setObject(x, forKey: "new_password" as NSCopying)
        }else
        {
            supportingfuction.showMessageHudWithMessage(message: "Please enter New Password." as NSString, delay: 2.0)
            return
            
        }
        if dataDict.object(forKey: "confirm_password") != nil &&  dataDict.object(forKey: "confirm_password") as! String != ""
        {
            
            if dataDict.object(forKey: "confirm_password")! as! String == dataDict.object(forKey: "new_password")! as! String
            {
                
            }else
            {
                supportingfuction.showMessageHudWithMessage(message: passwordMatch as NSString, delay: 2.0)
                return
            }
            
            
        }else
        {
            supportingfuction.showMessageHudWithMessage(message: enterConfirmPass as NSString, delay: 2.0)
            return
        }
        
       
     //   dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        dict.setObject(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id" as NSCopying)
        let apiSniper = APISniper()
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        apiSniper.getDataFromWebAPI(WebAPI.change_password,dict, {(operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary
            {   
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    if dataFromServer.object(forKey: "message") != nil
                    {
                         supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                        
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
    
    // MARK: - password validation
    func validationForPassword() -> Bool
    {
        if dataDict.object(forKey: "new_password") as? String != nil && dataDict.object(forKey: "new_password") as! String != ""
        {
            let passwordTrimmedString = (dataDict.object(forKey: "new_password") as! String).trimmingCharacters(in: CharacterSet.whitespaces)
            
            if(!CommonValidations.isValidPassword(testStr: passwordTrimmedString))
            {
                supportingfuction.showMessageHudWithMessage(message: validPassword as NSString, delay: 2.0)
                
                return false
            }else  if dataDict.object(forKey: "match_password") as? String != nil && dataDict.object(forKey: "match_password") as! String != ""
            {
                let passwordTrimmedString = (dataDict.object(forKey: "match_password") as! String).trimmingCharacters(in: CharacterSet.whitespaces)
                
                if(!CommonValidations.isValidPassword(testStr: passwordTrimmedString))
                {
                    supportingfuction.showMessageHudWithMessage(message: validPassword as NSString, delay: 2.0)
                    
                    return false
                }
                
            }
            
            
        }
        
        return true
    }
}
