//
//  ForgotPasswordView.swift
//  QuickHealthDoctorApp
//
//  Created by SS142 on 19/09/17.
//  Copyright © 2017 SS142. All rights reserved.
//

import UIKit

class ForgotPasswordView: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    
    @IBOutlet weak var tableView: UITableView?
    var email = String()
    var signUpDictionary = NSMutableDictionary()
    
    @IBOutlet weak var bgimage: UIImageView?
    var imagetoset = "Reset Password"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(VerifyOtpView.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(VerifyOtpView.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
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
            imagetoset = "forgotpassLandscape"
            //            self.tableView?.reloadData()
        } else {
            // print("portrait")
            imagetoset = "Reset Password"
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
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    //MARK:- TableView Delegate and Datasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        
        
        cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
       // let mainView = cell.viewWithTag(-1)
//        mainView?.layer.cornerRadius =  22
//        mainView?.layer.borderWidth = 1.0
//        mainView?.layer.borderColor = UIColor.white.cgColor
        
        let textField = cell.viewWithTag(2) as! UITextField
        let textView = cell.viewWithTag(2000) as! UITextView
        
        textField.isSecureTextEntry = false
        textField.isUserInteractionEnabled = true
        textField.keyboardType = UIKeyboardType.asciiCapable
        
        //let arrow = cell.viewWithTag(121) as! UIButton
        // arrow.isHidden = true
        
        let forgotTitle = cell.viewWithTag(1112) as! UILabel
        let attributedString = NSMutableAttributedString(string: "FORGOT PASSWORD")
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
        forgotTitle.attributedText = attributedString
        
        if signUpDictionary.object(forKey: "email") != nil &&
            signUpDictionary.object(forKey: "email") as! String != ""
        {
            textField.text = signUpDictionary.object(forKey: "email") as! String?
        }else
        {
            textField.attributedPlaceholder = NSAttributedString(string: "",
                                                                 attributes: [NSForegroundColorAttributeName: UIColor.white])
        }
        textField.keyboardType = UIKeyboardType.emailAddress
        let signupButton = cell.viewWithTag(999) as! UIButton
        signupButton.layer.cornerRadius = 5.0
        
        //iPhone
        print("iphone")
        let atrStr = NSMutableAttributedString(string: "Back to Login")
        atrStr.addAttribute(NSLinkAttributeName, value: "www.google.com", range: NSRange(location: 8, length: ("Login").utf16.count))
         atrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location: 8, length: ("Login").utf16.count))
        atrStr.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 8, length: ("Login").utf16.count))
        atrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 134.0 / 255.0, green: 135.0 / 255.0, blue: 138.0 / 255.0, alpha: 1.0), range: NSRange(location: 0, length: ("Back to").utf16.count))
        atrStr.addAttribute(NSFontAttributeName, value:UIFont(name: "Arimo-Regular", size: 15.0)! , range: NSRange(location: 8, length: ("Login").utf16.count))
        atrStr.addAttribute(NSFontAttributeName, value:UIFont(name: "Arimo-Regular", size: 15.0)! , range: NSRange(location: 0, length: ("Back to").utf16.count))
        
        textView.attributedText = atrStr
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.navigateToLogin))
        textView.addGestureRecognizer(tap)
        cell.backgroundColor = UIColor.clear
        return cell
        
    }
   
    func navigateToLogin()
    {
        _ = navigationController?.popViewController(animated: true)
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
    
    @IBAction func forgotPasswordBtnTapped(sender: UIButton)
    {
        self.view.endEditing(true)
        
        if signUpDictionary.object(forKey: "email") != nil && signUpDictionary.object(forKey: "email") as! String != ""
        {
            
            if (CommonValidations.isValidEmail(testStr: signUpDictionary.object(forKey: "email") as! String ) ) != false
            {
                if(!appDelegate.hasConnectivity())
                {
                    supportingfuction.showMessageHudWithMessage(message: NoInternetConnection as NSString, delay: 2.0)
                }
                else
                {
                    
                    if UserDefaults.standard.object(forKey: "access_token") == nil
                    {
                        appDelegate.getApiToken(completionHandler: {(data) in
                            self.forgotPass()
                        })
                    }
                    else
                    {
                        forgotPass()
                    }
                }
                
            }
            else
            {
        supportingfuction.showMessageHudWithMessage(message: validEmail as NSString , delay: 2.0)
         return
            }
        }
        else
        {
            supportingfuction.showMessageHudWithMessage(message: "Please enter email id.", delay: 2.0)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.characters.count)!>0
        {
        signUpDictionary.setObject(textField.text!, forKey: "email" as NSCopying)
        }else
        {
            signUpDictionary.setObject("", forKey: "email" as NSCopying)
        }
    }
   
    
    
    func forgotPass()
    {
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        
        dict.setObject(signUpDictionary.object(forKey: "email") as! String, forKey: "email" as NSCopying)
        dict.setObject("ios", forKey: "device_type" as NSCopying)
        dict.setObject("patient", forKey: "user_type" as NSCopying)

        
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPI(WebAPI.forgot_password,dict, {(operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    if dataFromServer.object(forKey: "message") != nil
                    {
                         _ = self.navigationController?.popViewController(animated: true)
                        supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                        
                    }
                }else
                {
                    supportingfuction.hideProgressHudInView(view: self)
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
