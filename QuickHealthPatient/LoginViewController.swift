//
//  ForgotPasswordView.swift
//  QuickHealthDoctorApp
//
//  Created by SS142 on 19/09/17.
//  Copyright © 2017 SS142. All rights reserved.
//
//  //login-2ipad
//login

import UIKit

class LoginViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView?
    
    @IBOutlet weak var textView: UITextView?
     @IBOutlet weak var bgimage: UIImageView?
    var imagetoset = "login"
    var signUpDictionary = NSMutableDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        textView?.delegate = self
        bgimage?.image = UIImage(named: imagetoset)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = true
        self.signUpDictionary.setObject("", forKey: "email" as NSCopying)
        self.signUpDictionary.setObject("", forKey: "password" as NSCopying)
        tableView?.reloadData()
        
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
          imagetoset = "login-2ipad"
//            self.tableView?.reloadData()
        } else {
            // print("portrait")
            imagetoset = "login"
//            self.tableView?.reloadData()//
        }
    }

    
    // MARK: - keyboard handling
    
    func keyboardWillShow(notification: NSNotification)
    {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.height, 0.0)
        tableView!.contentInset = contentInsets
        tableView!.scrollIndicatorInsets = contentInsets;
    }
    
    /**
     *  function to be called on keyboard get invisible
     *
     *  @param notification reference of NSNotification
     */
    
    
    func keyboardWillHide(notification: NSNotification)
    {
        let contentInsets = UIEdgeInsets.zero as UIEdgeInsets
        tableView!.contentInset = contentInsets
        tableView!.scrollIndicatorInsets = contentInsets;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        let hit = textField.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView?.indexPathForRow(at: hit)
        let cell = tableView?.cellForRow(at: indexPath!)
        
        if textField.tag == 1
        {
            let txtf = cell?.viewWithTag(2)
            txtf?.becomeFirstResponder()
        }
        else if textField.tag == 2
        {
            
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideKeyboard()
    {
        self.view.endEditing(true)
    }
    
    //MARK:- TableView Delegate and Datasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
        let textFieldEmail = cell.viewWithTag(1) as! UITextField
        let textFieldPasswodr = cell.viewWithTag(2) as! UITextField
        let textView = cell.viewWithTag(2000) as! UITextView
        let loginButton = cell.viewWithTag(999) as! UIButton
        loginButton.layer.cornerRadius = 5.0
        //-789
         cell.backgroundColor = UIColor.clear
        textFieldEmail.keyboardType = .emailAddress
        textFieldPasswodr.isSecureTextEntry = true
        
        textFieldEmail.returnKeyType = .next
        textFieldPasswodr.returnKeyType = .done
        
        //iPhone
        print("iphone")
        let atrStr = NSMutableAttributedString(string: "Don't have an account? Sign Up.")
        atrStr.addAttribute(NSLinkAttributeName, value: "www.google.com", range: NSRange(location: 23, length: ("Sign Up.").utf16.count))
        atrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location: 23, length: ("Sign Up.").utf16.count))
        atrStr.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 23, length: ("Sign Up.").utf16.count))
        
        atrStr.addAttribute(NSFontAttributeName, value:UIFont(name: "Arimo-Regular", size: 15.0)! , range: NSRange(location: 23, length: ("Sign Up.").utf16.count))
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.navigateToSignup))
        textView.addGestureRecognizer(tap)
        
        textView.attributedText = atrStr
        
        if signUpDictionary.object(forKey: "email") != nil && signUpDictionary.object(forKey: "email") as! String != ""
        {
            textFieldEmail.text = signUpDictionary.object(forKey: "email") as? String
        }else
        {
            textFieldEmail.text = ""
        }
        
        
        if signUpDictionary.object(forKey: "password") != nil && signUpDictionary.object(forKey: "password") as! String != ""
        {
            textFieldPasswodr.text = signUpDictionary.object(forKey: "password") as? String
        }else
        {
            textFieldPasswodr.text = ""
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height-40
    }

    
    func navigateToSignup()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupView") as! SignupView
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func ResetPasswordBtnTapped(sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordView") as! ForgotPasswordView
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginBtnTApped(sender: UIButton)
    {
        
        self.view.endEditing(true)
        
        if let x = signUpDictionary.object(forKey: "email") as? String,x.characters.count != 0{
            
            if (CommonValidations.isValidEmail(testStr: signUpDictionary.object(forKey: "email") as! String ) ) == false
            {
                supportingfuction.showMessageHudWithMessage(message: validEmail as NSString, delay: 2.0)
                return
            }
        }
         
        else{
            supportingfuction.showMessageHudWithMessage(message: "Please enter email id." as NSString, delay: 2.0)
            return
        }
        
        if let x = signUpDictionary.object(forKey: "password") as? String,x.characters.count != 0{
           
        }
        else{
            supportingfuction.showMessageHudWithMessage(message: "Please enter password." as NSString, delay: 2.0)
            return
        }
        
        
        
        if let x = signUpDictionary.object(forKey: "password") as? String,x.characters.count != 0{
            
        }else{
            supportingfuction.showMessageHudWithMessage(message: "Please enter password." as NSString, delay: 2.0)
            return
        }
        if(!appDelegate.hasConnectivity())
        {
            supportingfuction.showMessageHudWithMessage(message: NoInternetConnection as NSString, delay: 2.0)
        }
        else
        {
            if UserDefaults.standard.object(forKey: "access_token") == nil
            {
                appDelegate.getApiToken(completionHandler: {(data) in
                    self.loginWebService()
            })
            }
            else
            {
                loginWebService()
            }
        }
        
        
        
        
    }
    
    func validationForPassword() -> Bool
    {
        if signUpDictionary.object(forKey: "password") as? String != nil && signUpDictionary.object(forKey: "password") as! String != ""
        {
            let passwordTrimmedString = (signUpDictionary.object(forKey: "password") as! String).trimmingCharacters(in: CharacterSet.whitespaces)
            
            if(!CommonValidations.isValidPassword(testStr: passwordTrimmedString))
            {
                supportingfuction.showMessageHudWithMessage(message: validPassword as NSString, delay: 2.0)
                
                return false
            }else  if signUpDictionary.object(forKey: "match_password") as? String != nil && signUpDictionary.object(forKey: "match_password") as! String != ""
            {
                let passwordTrimmedString = (signUpDictionary.object(forKey: "match_password") as! String).trimmingCharacters(in: CharacterSet.whitespaces)
                
                if(!CommonValidations.isValidPassword(testStr: passwordTrimmedString))
                {
                    supportingfuction.showMessageHudWithMessage(message: validPassword as NSString, delay: 2.0)
                    
                    return false
                }
                
            }
            
            
        }
        
        return true
    }
    
    @IBAction func backBtnTapped(sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1
        {
            
            if textField.text != ""
            {
                signUpDictionary.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "email" as NSCopying)
                
            }else
            {
                signUpDictionary.setObject("", forKey: "email" as NSCopying)
            }
            
        }else if textField.tag == 2
        {
            if textField.text != ""
            {
                signUpDictionary.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "password" as NSCopying)
                
            }else
            {
                signUpDictionary.setObject("", forKey: "password" as NSCopying)
            }
            
        }
        
    }
    
  
    
    
    func loginWebService()
    {
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        
        dict.setObject(signUpDictionary.object(forKey: "email") as! String, forKey: "email" as NSCopying)
        dict.setObject(signUpDictionary.object(forKey: "password") as! String, forKey: "password" as NSCopying)
        dict.setObject("patient", forKey: "user_type" as NSCopying)
        let apiSniper = APISniper()
        
        
        apiSniper.getDataFromWebAPI(WebAPI.login_webmethod,dict, {(operation, responseObject) in
            
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
                        
                        if (dataFromServer.object(forKey: "data") as! NSDictionary).object(forKey: "id_user") != nil && (dataFromServer.object(forKey: "data") as! NSDictionary).object(forKey: "id_user") is NSNull == false && (dataFromServer.object(forKey: "data") as! NSDictionary).object(forKey: "id_user") as! String != ""
                        {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOtpView") as! VerifyOtpView
                            vc.user_idToSend = ((dataFromServer.object(forKey: "data") as! NSDictionary).object(forKey: "id_user") as! String)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }else
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
}
