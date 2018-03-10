//
//  PresentConditionViewController.swift
//  QuickHealthPatient
//
//  Created by SL159 on 11/01/18.
//  Copyright © 2018 SL161. All rights reserved.
//

import UIKit

class PresentConditionViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var headerTitle: UILabel!
    
  
    var ApptSend_slotIDtoSend = ""
    var ApptSend_serviceID = ""
    var ApptSend_doctorsID = ""
    var ApptSend_user_type = ""
    var ApptSend_child_ID = ""
    var apptSend_purpose = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 265.0
        tableView.rowHeight = UITableViewAutomaticDimension
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if (UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).count>0  &&  ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "first_name")) != nil
            && ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "first_name")) as! String != ""
        {
        headerTitle.text = "Hi \(((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "first_name")) as! String), how can we help you?"
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        if (text == "\n")
        {
            //self.view.endEditing(true)
            //            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
     apptSend_purpose = textView.text
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if (sender as! UIButton).tag == 3 && apptSend_purpose.trimmingCharacters(in: CharacterSet.whitespaces) == ""
        {
            supportingfuction.showMessageHudWithMessage(message: "Please enter description." as NSString, delay: 2.0)
            return
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddDocumentsView") as! AddDocumentsView
        vc.ApptSend_slotIDtoSend = ApptSend_slotIDtoSend
        vc.ApptSend_serviceID = ApptSend_serviceID
        vc.ApptSend_doctorsID = ApptSend_doctorsID
        vc.ApptSend_user_type = ApptSend_user_type
        vc.ApptSend_child_ID = ApptSend_child_ID
        vc.apptSend_purpose = apptSend_purpose
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtnTapper(sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
}

extension PresentConditionViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PresentConditionViewControllerCell", for: indexPath)
        
        let descriptionTextView = cell.viewWithTag(1) as! UITextView
        descriptionTextView.delegate = self
        //descriptionTextView.text = ""
        let skipButton = cell.viewWithTag(2) as! UIButton
        skipButton.layer.cornerRadius = 3
        skipButton.clipsToBounds = true
        
        let saveAndProceedButton = cell.viewWithTag(3) as! UIButton
        saveAndProceedButton.layer.cornerRadius = 3
        saveAndProceedButton.clipsToBounds = true
        
        return cell
    }
}




