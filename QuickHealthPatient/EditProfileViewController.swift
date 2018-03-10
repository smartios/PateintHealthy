//
//  EditProfileViewController.swift
//  QuickHealthDoctorApp
//
//  Created by SS142 on 18/09/17.
//  Copyright © 2017 SS142. All rights reserved.
//

import UIKit
import GooglePlaces


class EditProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate,UIActionSheetDelegate,countryList,childList {
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var imagetoset = "signupimg"
    var ncode = ""
    var checkBoxSelection = false
    var childDataArray = NSMutableArray()
    
    var dataArray = [" ","FIRST NAME","LAST NAME","DATE OF BIRTH","GENDER","OCCUPATION","MOBILE NUMBER","EMAIL ADDRESS","ADDRESS","STREET ADDRESS","CITY","LOCATION","AREA CODE","COUNTRY","LANGUAGE" ,"MARITAL STATUS"]
    var signupDataDict = NSMutableDictionary()
    let imagePicker = UIImagePickerController()
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var placesClient: GMSPlacesClient = GMSPlacesClient()
    var galleryImage = UIImage()
    var imageData = NSData()
    var imageEdited = false
    let Picker:UIImagePickerController! = UIImagePickerController()
    var passwordShow = false
    
    var dropDownFor = ""
    var tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //signupDataDict.setObject("Male", forKey: "gender" as NSCopying)
        
        if let x = signupDataDict.object(forKey: "dob") as? String
        {
            signupDataDict.setValue(x, forKey: ("date_of_birth" as NSCopying) as! String)
        }
        
        if let x = signupDataDict.object(forKey: "mobile") as? String
        {
            signupDataDict.setValue(x, forKey: ("mobile_number" as NSCopying) as! String)
        }
        
        tableView?.backgroundColor = UIColor.clear
        imagePicker.delegate = self
        //////////for current location////////////////
        placesClient = GMSPlacesClient.shared()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        //////////for current location////////////////
        
        
        
        //Date picker for DOB
        datePickerView.isHidden = true
        datePickerView.isHidden = true
        datePicker.datePickerMode = UIDatePickerMode.date
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.popToRootView), name: NSNotification.Name(rawValue: "popToRootView"), object: nil)
        
        // Do any additional setup after loading the view.
        
    }
    
    
    /// Hide keyboard when user taps anywhere on the screen.
    @objc func hideKeyboard()
    {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        //login-2ipad
        //login
        if (size.width / size.height > 1) {
            // print("landscape")
            imagetoset = "signupimgLanding"
            self.tableView?.reloadData()
        } else {
            // print("portrait")
            imagetoset = "signupimg"
            self.tableView?.reloadData()//
        }
    }
    
    func popToRootView()
        
        
    {
        tapResponse()
        
        
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    // MARK: - keyboard handling
    
    func keyboardWillShow(notification: NSNotification)
    {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.height, 0.0)
        
        
        
        tableView!.contentInset = contentInsets
        tableView!.scrollIndicatorInsets = contentInsets;
        
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        
        tableView?.addGestureRecognizer(tapGesture)
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
        
        tableView?.removeGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        let hit = textField.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView?.indexPathForRow(at: hit)
        
        if indexPath?.row == 3 ||  indexPath?.row == 5 ||  indexPath?.row == 14
        {
            textField.resignFirstResponder()
        }
        else {
            // create custom indexpath for same textfield
            let nexCell = (tableView?.cellForRow(at: IndexPath(row: (indexPath?.row)! + 1, section: 0)))! as UITableViewCell
            
            ((nexCell).viewWithTag(2) as! UITextField).becomeFirstResponder()
        }
        return true
    }
    
    
    
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let pointInTable: CGPoint = textField.convert(textField.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView?.indexPathForRow(at: pointInTable)
        print(cellIndexPath!)
        
        if cellIndexPath![1] == 1
        {
            if textField.text != ""
            {
                signupDataDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "first_name" as NSCopying)
            }else
            {
                signupDataDict.setObject("", forKey: "first_name" as NSCopying)
                
            }
        }else if cellIndexPath![1] == 2
        {
            if textField.text != ""
            {
                signupDataDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "last_name" as NSCopying)
            }else
            {
                signupDataDict.setObject("", forKey: "last_name" as NSCopying)
                
            }
        }else if cellIndexPath![1] == 3
        {
            if textField.text != ""
            {
                signupDataDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "date_of_birth" as NSCopying)
            }else
            {
                signupDataDict.setObject("", forKey: "date_of_birth" as NSCopying)
                
            }
        }else if cellIndexPath![1] == 4
        {
            if textField.text != ""
            {
                signupDataDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "gender" as NSCopying)
            }else
            {
                signupDataDict.setObject("", forKey: "gender" as NSCopying)
                
            }
        }
            
        else if cellIndexPath![1] == 5
        {
            if textField.text != ""
            {
                signupDataDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "occupation" as NSCopying)
            }else
            {
                signupDataDict.setObject("", forKey: "occupation" as NSCopying)
                
            }
        }
            
            
            
        else if cellIndexPath![1] == 6
        {
            if textField.text != ""
            {
                signupDataDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "email" as NSCopying)
            }else
            {
                signupDataDict.setObject("", forKey: "email" as NSCopying)
                
            }
        }else if cellIndexPath![1] == 7
        {
            if textField.text != ""
            {
                signupDataDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "mobile_number" as NSCopying)
            }else
            {
                signupDataDict.setObject("", forKey: "mobile_number" as NSCopying)
                
            }
        }else if cellIndexPath![1] == 8
        {
            if textField.text != ""
            {
                signupDataDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "address" as NSCopying)
            }else
            {
                signupDataDict.setObject("", forKey: "address" as NSCopying)
                
            }
        }else if cellIndexPath![1] == 9
        {
            if textField.text != ""
            {
                signupDataDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "street_name" as NSCopying)
            }else
            {
                signupDataDict.setObject("", forKey: "street_name" as NSCopying)
                
            }
        }else if cellIndexPath![1] == 10
        {
            if textField.text != ""
            {
                signupDataDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "city" as NSCopying)
            }else
            {
                signupDataDict.setObject("", forKey: "city" as NSCopying)
                
            }
        }else if cellIndexPath![1] == 11
        {
            if textField.text != ""
            {
                signupDataDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "state" as NSCopying)
            }else
            {
                signupDataDict.setObject("", forKey: "state" as NSCopying)
                
            }
        }else if cellIndexPath![1] == 12
        {
            if textField.text != ""
            {
                signupDataDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "area_code" as NSCopying)
            }else
            {
                signupDataDict.setObject("", forKey: "area_code" as NSCopying)
                
            }
        }else if cellIndexPath![1] == 13
        {
            if textField.text != ""
            {
                signupDataDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "country" as NSCopying)
            }else
            {
                signupDataDict.setObject("", forKey: "country" as NSCopying)
                
            }
        }
            
        else if cellIndexPath![1] == 14
        {
            if textField.text != ""
            {
                signupDataDict.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "language" as NSCopying)
            }else
            {
                signupDataDict.setObject("", forKey: "language" as NSCopying)
                
            }
        }
        //
    }
    
    //MARK:- TableView Delegate and Datasource
    
    // MARK: - table view delegate methods
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("FAQHeader", owner: self, options: nil)?[0] as! UIView
        let bgImage = headerView.viewWithTag(11) as! UIImageView
        let profileImg = headerView.viewWithTag(12) as! UIImageView
        let userName = headerView.viewWithTag(13) as! UILabel
        let idLbl = headerView.viewWithTag(-40) as! UILabel
        
        let editProfile = headerView.viewWithTag(-111) as! UIButton
        editProfile.isUserInteractionEnabled = true
        editProfile.addTarget(self, action: #selector(self.imagePickerBtn(_:)), for: UIControlEvents.touchUpInside)
        profileImg.layer.cornerRadius = (profileImg.frame.height)/2
        profileImg.clipsToBounds = true
        
        headerView.tag = section
        userName.font = UIFont(name: "OpenSans-Bold_0", size: 16)
        if imageEdited == true
        {
            profileImg.image = signupDataDict.object(forKey: "image") != nil ? signupDataDict.object(forKey: "image") as! UIImage : #imageLiteral(resourceName: "profile")
        }
        else{
            if let x = (signupDataDict.object(forKey: "user_image") as? String)
            {
                profileImg.setImageWith(NSURL(string: x) as! URL, placeholderImage: UIImage(named: "landing_image"))
            }else
            {
                profileImg.image = #imageLiteral(resourceName: "landing_image")
            }
        }
        
        if let x = ((signupDataDict.object(forKey: "first_name") as? String))?.uppercased()
        {
            if let y = ((signupDataDict.object(forKey: "last_name") as? String))?.uppercased()
            {
                userName.text = x + " " +  y
            }
        }
        
        idLbl.isHidden = false
        
        if let x = (signupDataDict.object(forKey: "unique_number") as? String)
        {
            idLbl.text = "ID-\(x)"
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 240
        }else
        {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return dataArray.count
        }else
        {
            if childDataArray.count > 0
            {
                return childDataArray.count + 2
            }else
            {
                return 2
            }
            
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
                let profileImg = cell.viewWithTag(999) as! UIImageView
                let bgimage = cell.viewWithTag(1) as! UIImageView
                bgimage.image = UIImage(named: imagetoset)
                
                profileImg.layer.cornerRadius = profileImg.frame.width/2
                profileImg.layer.borderWidth = 1.0
                profileImg.layer.borderColor = UIColor.clear.cgColor
                profileImg.clipsToBounds = true
                cell.backgroundColor = UIColor.clear
                if let x = self.signupDataDict.object(forKey: "image") as? UIImage{
                    profileImg.image = x
                }
                
                
            }
            else if indexPath.row == 1
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
                
                let title = cell.viewWithTag(1) as!  UILabel
                let textField = cell.viewWithTag(2) as! UITextField
                let arrow = cell.viewWithTag(3) as! UIButton
                cell.backgroundColor = UIColor.clear
                textField.isSecureTextEntry = false
                textField.isUserInteractionEnabled = true
                textField.keyboardType = UIKeyboardType.asciiCapable
                textField.autocapitalizationType = UITextAutocapitalizationType.sentences
                textField.placeholder = dataArray[indexPath.row]
                textField.returnKeyType = .next
                textField.isEnabled = true
                
                title.text = dataArray[indexPath.row]
                if signupDataDict.object(forKey: "first_name") != nil && signupDataDict.object(forKey: "first_name") as! String != ""
                {
                    textField.text = signupDataDict.object(forKey: "first_name") as? String
                }else
                {
                    textField.text = ""
                }
                
                
                
                arrow.isHidden = true
                
            }
            else if indexPath.row == 2
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
                
                let title = cell.viewWithTag(1) as!  UILabel
                let textField = cell.viewWithTag(2) as! UITextField
                let arrow = cell.viewWithTag(3) as! UIButton
                cell.backgroundColor = UIColor.clear
                
                textField.isSecureTextEntry = false
                textField.isUserInteractionEnabled = true
                textField.keyboardType = UIKeyboardType.asciiCapable
                textField.autocapitalizationType = UITextAutocapitalizationType.sentences
                textField.placeholder = dataArray[indexPath.row]
                textField.returnKeyType = .default
                textField.isEnabled = true
                
                title.text = dataArray[indexPath.row]
                if signupDataDict.object(forKey: "last_name") != nil && signupDataDict.object(forKey: "last_name") as! String != ""
                {
                    textField.text = signupDataDict.object(forKey: "last_name") as? String
                }else
                {
                    textField.text = ""
                }
                
                
                
                arrow.isHidden = true
            }
                
            else if indexPath.row == 3
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
                
                let title = cell.viewWithTag(1) as!  UILabel
                let textField = cell.viewWithTag(2) as! UITextField
                let arrow = cell.viewWithTag(3) as! UIButton
                cell.backgroundColor = UIColor.clear
                
                textField.isSecureTextEntry = false
                textField.isUserInteractionEnabled = false
                textField.keyboardType = UIKeyboardType.asciiCapable
                textField.autocapitalizationType = UITextAutocapitalizationType.sentences
                textField.placeholder = dataArray[indexPath.row]
                textField.isEnabled = true
                
                title.text = dataArray[indexPath.row]
                if signupDataDict.object(forKey: "date_of_birth") != nil && signupDataDict.object(forKey: "date_of_birth") as! String != ""
                {
                    textField.text = signupDataDict.object(forKey: "date_of_birth") as? String
                }else
                {
                    textField.text = ""
                }
                
                let atrStr = NSMutableAttributedString(string: "")
                arrow.setAttributedTitle(atrStr, for: .normal)
                arrow.setImage(#imageLiteral(resourceName: "calender"), for: .normal)
                arrow.isHidden = false
                arrow.isUserInteractionEnabled = false
                
                
            }
                
            else if indexPath.row == 4
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell6")
                
                let title = cell.viewWithTag(1) as!  UILabel
                let maleBTn = cell.viewWithTag(-2) as! UIButton
                let femaleBTn = cell.viewWithTag(-3) as! UIButton
                title.text = dataArray[indexPath.row]
                
                if signupDataDict.object(forKey: "gender") as! String == "Male"
                {
                    maleBTn.isSelected = true
                    femaleBTn.isSelected = false
                }else if signupDataDict.object(forKey: "gender") as! String == "Female"
                {
                    maleBTn.isSelected = false
                    femaleBTn.isSelected = true
                }else
                {
                    maleBTn.isSelected = false
                    femaleBTn.isSelected = false
                }
                
                
            }
                
            else if indexPath.row == 5
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
                
                let title = cell.viewWithTag(1) as!  UILabel
                let textField = cell.viewWithTag(2) as! UITextField
                let arrow = cell.viewWithTag(3) as! UIButton
                cell.backgroundColor = UIColor.clear
                
                textField.isSecureTextEntry = false
                textField.isUserInteractionEnabled = true
                textField.keyboardType = UIKeyboardType.asciiCapable
                textField.autocapitalizationType = UITextAutocapitalizationType.sentences
                textField.placeholder = dataArray[indexPath.row]
                textField.returnKeyType = .default
                textField.isEnabled = true
                
                title.text = dataArray[indexPath.row]
                if signupDataDict.object(forKey: "occupation") != nil && signupDataDict.object(forKey: "occupation") as! String != ""
                {
                    textField.text = signupDataDict.object(forKey: "occupation") as? String
                }else
                {
                    textField.text = ""
                }
                
                
                
                arrow.isHidden = true
            }
                
                
            else if indexPath.row == 7
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
                
                let title = cell.viewWithTag(1) as!  UILabel
                let textField = cell.viewWithTag(2) as! UITextField
                let arrow = cell.viewWithTag(3) as! UIButton
                cell.backgroundColor = UIColor.clear
                
                textField.isSecureTextEntry = false
                textField.isUserInteractionEnabled = true
                textField.keyboardType = UIKeyboardType.emailAddress
                textField.placeholder = dataArray[indexPath.row]
                textField.returnKeyType = .default
                textField.isEnabled = false
                title.text = dataArray[indexPath.row]
                
                
                if signupDataDict.object(forKey: "email") != nil && signupDataDict.object(forKey: "email") as! String != ""
                {
                    textField.text = signupDataDict.object(forKey: "email") as? String
                }else
                {
                    textField.text = ""
                }
                
                arrow.isHidden = true
            }
                
                
            else if indexPath.row == 6
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell4")
                
                let title = cell.viewWithTag(1) as!  UILabel
                let textField = cell.viewWithTag(3) as! UITextField
                textField.isSecureTextEntry = false
                textField.isUserInteractionEnabled = true
                let arrow = cell.viewWithTag(-2) as! UIButton
                title.text = dataArray[indexPath.row]
                textField.keyboardType = UIKeyboardType.numberPad
                cell.backgroundColor = UIColor.clear
                textField.placeholder = dataArray[indexPath.row]
                textField.isEnabled = true
                
                arrow.addTarget(self, action: #selector(countryCodewebService), for: .touchUpInside)
                arrow.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
                
                arrow.isHidden = false
                arrow.isUserInteractionEnabled = true
                let keyboardDoneButtonShow =  UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/17))
                let paddingViewleft2 = UIView(frame:  CGRect(x: 0, y: 0, width: 8, height: 30))
                textField.leftView = paddingViewleft2
                textField.leftViewMode = UITextFieldViewMode.always
                //Setting the style for the toolbar
                keyboardDoneButtonShow.barStyle = UIBarStyle .default
                //Making the done button and calling the textFieldShouldReturn native method for hidding the keyboard.
                let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(EditProfileViewController.hideKeyboard))
                //Calculating the flexible Space.
                let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
                //Setting the color of the button.
                doneButton.tintColor = UIColor.black
                //Making an object using the button and space for the toolbar
                let toolbarButton = [flexSpace,doneButton]
                //Adding the object for toolbar to the toolbar itself
                keyboardDoneButtonShow.setItems(toolbarButton, animated: false)
                //Now adding the complete thing against the desired textfield
                textField.inputAccessoryView = keyboardDoneButtonShow
                
                
                if signupDataDict.object(forKey: "mobile_number") != nil && signupDataDict.object(forKey: "mobile_number") is NSNull == false && signupDataDict.object(forKey: "mobile_number") as! String != ""
                {
                    textField.text = signupDataDict.object(forKey: "mobile_number") as? String
                }else
                {
                    textField.text = ""
                }
                //mobile_ext
                
                
                if signupDataDict.object(forKey: "mobile_ext") != nil && signupDataDict.object(forKey: "mobile_ext") is NSNull == false && signupDataDict.object(forKey: "mobile_ext") as! String != ""
                {
                    
                    arrow.setTitle(signupDataDict.object(forKey: "mobile_ext") as? String, for: .normal)
                    
                }else
                {
                    arrow.setTitle("+65", for: .normal)
                }
                
            }
                
            else if indexPath.row == 8
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
                
                let title = cell.viewWithTag(1) as!  UILabel
                let textField = cell.viewWithTag(2) as! UITextField
                let arrow = cell.viewWithTag(3) as! UIButton
                cell.backgroundColor = UIColor.clear
                
                textField.isSecureTextEntry = false
                textField.isUserInteractionEnabled = false
                textField.keyboardType = UIKeyboardType.asciiCapable
                textField.autocapitalizationType = UITextAutocapitalizationType.sentences
                textField.placeholder = dataArray[indexPath.row]
                textField.isEnabled = true
                
                title.text = dataArray[indexPath.row]
                if signupDataDict.object(forKey: "address") != nil && signupDataDict.object(forKey: "address") as! String != ""
                {
                    textField.text = signupDataDict.object(forKey: "address") as? String
                }else
                {
                    textField.text = ""
                }
                
                let atrStr = NSMutableAttributedString(string: "")
                arrow.setAttributedTitle(atrStr, for: .normal)
                arrow.setImage(#imageLiteral(resourceName: "location@"), for: .normal)
                
                arrow.isHidden = false
                arrow.isUserInteractionEnabled = true
            }
            else if indexPath.row == 9
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
                
                let title = cell.viewWithTag(1) as!  UILabel
                let textField = cell.viewWithTag(2) as! UITextField
                let arrow = cell.viewWithTag(3) as! UIButton
                cell.backgroundColor = UIColor.clear
                
                textField.isSecureTextEntry = false
                textField.isUserInteractionEnabled = true
                textField.keyboardType = UIKeyboardType.asciiCapable
                textField.autocapitalizationType = UITextAutocapitalizationType.sentences
                textField.placeholder = dataArray[indexPath.row]
                textField.returnKeyType = .next
                textField.isEnabled = true
                
                title.text = dataArray[indexPath.row]
                if signupDataDict.object(forKey: "street_name") != nil && signupDataDict.object(forKey: "street_name") as! String != ""
                {
                    textField.text = signupDataDict.object(forKey: "street_name") as? String
                }else
                {
                    textField.text = ""
                }
                
                arrow.isHidden = true
            }
            else if indexPath.row == 10
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
                
                let title = cell.viewWithTag(1) as!  UILabel
                let textField = cell.viewWithTag(2) as! UITextField
                let arrow = cell.viewWithTag(3) as! UIButton
                cell.backgroundColor = UIColor.clear
                
                textField.isSecureTextEntry = false
                textField.isUserInteractionEnabled = true
                textField.keyboardType = UIKeyboardType.asciiCapable
                textField.autocapitalizationType = UITextAutocapitalizationType.sentences
                textField.placeholder = dataArray[indexPath.row]
                textField.returnKeyType = .next
                textField.isEnabled = true
                
                title.text = dataArray[indexPath.row]
                if signupDataDict.object(forKey: "city") != nil && signupDataDict.object(forKey: "city") as! String != ""
                {
                    textField.text = signupDataDict.object(forKey: "city") as? String
                }else
                {
                    textField.text = ""
                }
                
                arrow.isHidden = true
                
            }
            else if indexPath.row == 11
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
                
                let title = cell.viewWithTag(1) as!  UILabel
                let textField = cell.viewWithTag(2) as! UITextField
                let arrow = cell.viewWithTag(3) as! UIButton
                cell.backgroundColor = UIColor.clear
                
                textField.isSecureTextEntry = false
                textField.isUserInteractionEnabled = true
                textField.keyboardType = UIKeyboardType.asciiCapable
                textField.autocapitalizationType = UITextAutocapitalizationType.sentences
                textField.placeholder = dataArray[indexPath.row]
                textField.returnKeyType = .next
                textField.isEnabled = true
                
                title.text = dataArray[indexPath.row]
                if signupDataDict.object(forKey: "state") != nil && signupDataDict.object(forKey: "state") as! String != ""
                {
                    textField.text = signupDataDict.object(forKey: "state") as? String
                }else
                {
                    textField.text = ""
                }
                
                
                
                arrow.isHidden = true
                
            }
            else if indexPath.row == 12
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
                
                let title = cell.viewWithTag(1) as!  UILabel
                let textField = cell.viewWithTag(2) as! UITextField
                let arrow = cell.viewWithTag(3) as! UIButton
                cell.backgroundColor = UIColor.clear
                
                textField.isSecureTextEntry = false
                textField.isUserInteractionEnabled = true
                
                textField.autocapitalizationType = UITextAutocapitalizationType.sentences
                textField.placeholder = dataArray[indexPath.row]
                textField.isEnabled = true
                
                title.text = dataArray[indexPath.row]
                if signupDataDict.object(forKey: "area_code") != nil && signupDataDict.object(forKey: "area_code") as! String != ""
                {
                    textField.text = signupDataDict.object(forKey: "area_code") as? String
                }else
                {
                    textField.text = ""
                }
                textField.keyboardType = UIKeyboardType.numberPad
                let keyboardDoneButtonShow =  UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/17))
                
                
                textField.leftViewMode = UITextFieldViewMode.always
                //Setting the style for the toolbar
                keyboardDoneButtonShow.barStyle = UIBarStyle .default
                //Making the done button and calling the textFieldShouldReturn native method for hidding the keyboard.
                let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(EditProfileViewController.hideKeyboard))
                //Calculating the flexible Space.
                let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
                //Setting the color of the button.
                doneButton.tintColor = UIColor.black
                //Making an object using the button and space for the toolbar
                let toolbarButton = [flexSpace,doneButton]
                //Adding the object for toolbar to the toolbar itself
                keyboardDoneButtonShow.setItems(toolbarButton, animated: false)
                //Now adding the complete thing against the desired textfield
                textField.inputAccessoryView = keyboardDoneButtonShow
                
                arrow.isHidden = true
                
            }
            else if indexPath.row == 13
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
                
                let title = cell.viewWithTag(1) as!  UILabel
                let textField = cell.viewWithTag(2) as! UITextField
                let arrow = cell.viewWithTag(3) as! UIButton
                cell.backgroundColor = UIColor.clear
                
                textField.isSecureTextEntry = false
                textField.isUserInteractionEnabled = false
                textField.keyboardType = UIKeyboardType.asciiCapable
                textField.autocapitalizationType = UITextAutocapitalizationType.sentences
                textField.placeholder = dataArray[indexPath.row]
                textField.isEnabled = true
                
                title.text = dataArray[indexPath.row]
                if signupDataDict.object(forKey: "country") != nil && signupDataDict.object(forKey: "country") as! String != ""
                {
                    textField.text = signupDataDict.object(forKey: "country") as? String
                }else
                {
                    textField.text = ""
                }
                
                
                arrow.isHidden = true
            }
                
                
            else if indexPath.row == 14
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
                
                let title = cell.viewWithTag(1) as!  UILabel
                let textField = cell.viewWithTag(2) as! UITextField
                let arrow = cell.viewWithTag(3) as! UIButton
                cell.backgroundColor = UIColor.clear
                
                textField.isSecureTextEntry = false
                textField.isUserInteractionEnabled = false
                textField.keyboardType = UIKeyboardType.asciiCapable
                textField.autocapitalizationType = UITextAutocapitalizationType.sentences
                textField.placeholder = dataArray[indexPath.row]
                textField.isEnabled = true
                
                title.text = dataArray[indexPath.row]
                if signupDataDict.object(forKey: "language") != nil && signupDataDict.object(forKey: "language") as! String != ""
                {
                    textField.text = signupDataDict.object(forKey: "language") as? String
                }else
                {
                    textField.text = ""
                }
                
                
                arrow.isHidden = true
            }
                
            else if indexPath.row == 15
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
                
                let title = cell.viewWithTag(1) as!  UILabel
                let textField = cell.viewWithTag(2) as! UITextField
                let arrow = cell.viewWithTag(3) as! UIButton
                cell.backgroundColor = UIColor.clear
                
                textField.isSecureTextEntry = false
                textField.isUserInteractionEnabled = false
                textField.keyboardType = UIKeyboardType.asciiCapable
                textField.autocapitalizationType = UITextAutocapitalizationType.sentences
                textField.placeholder = dataArray[indexPath.row]
                textField.isEnabled = true
                
                title.text = dataArray[indexPath.row]
                if signupDataDict.object(forKey: "maritualstatus") != nil && signupDataDict.object(forKey: "maritualstatus") as! String != ""
                {
                    textField.text = signupDataDict.object(forKey: "maritualstatus") as? String
                }else
                {
                    textField.text = ""
                }
                
                
                arrow.isHidden = true
            }
            
            
            
        }
        else
        {
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "childheaderCell")
            }
            else if indexPath.row == childDataArray.count + 1
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell3")
            }
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "childdescCell")
                let nameLbl = cell.viewWithTag(1) as! UILabel
                let dobLbl = cell.viewWithTag(2) as! UILabel
                let genderLbl = cell.viewWithTag(3) as! UILabel
                let idLbl = cell.viewWithTag(4) as! UILabel
                let genderImg = cell.viewWithTag(-3) as! UIImageView
                
                if childDataArray.count > 0
                {
                    nameLbl.text = ((childDataArray.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "first_name") as! String)
                    dobLbl.text = ((childDataArray.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "dob") as! String)
                    
                    if let x = ((childDataArray.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "gender") as? String)
                    {
                        genderLbl.text = ((childDataArray.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "gender") as! String)
                        
                        //                        if x.lowercased() == "female"
                        //                        {
                        //                            genderImg.image = #imageLiteral(resourceName: "femalegender")
                        //                        }else
                        //                        {
                        genderImg.image = #imageLiteral(resourceName: "gender")
                        //                        }
                    }
                    
                    
                    idLbl.text = ((childDataArray.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "id_child") as! String)
                }
            }
        }
        
        return cell
        
    }
    
    
    func countryCodewebService()
    {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "CountryCodeViewController") as! CountryCodeViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    @IBAction func bckBtnTapped(sender: UIButton)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if indexPath.row == 3
        {
            dropDownFor = ""
            datePickerView.isHidden = false
            // datePicker.maximumDate = NSDate() as Date
            self.view.endEditing(true)
            return
        }
        if indexPath.row == 8
        {
            dropDownFor = ""
            print("address filed selected")
            
            // Present the Autocomplete view controller when the button is pressed.
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
        }
        if indexPath.row == 13
        {
            dropDownFor = ""
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "CountryCodeViewController") as! CountryCodeViewController
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.row == 14
        {
            dropDownFor = "langauge"
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "CountryCodeViewController") as! CountryCodeViewController
            vc.commfor = "language"
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        if indexPath.row == 15
        {
            dropDownFor = "maritualstatus"
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "CountryCodeViewController") as! CountryCodeViewController
            vc.commfor = "maritualstatus"
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                if UIDevice.current.userInterfaceIdiom == .pad
                {
                    return 0
                }else
                {
                    return 0
                }
                
            }else if indexPath.row == 4
            {
                return 80
            }
            else
            {
                return 55
            }
        }else
        {
            if indexPath.row == 0
            {
                return 55
            }
            else if indexPath.row == childDataArray.count + 1
            {
                return 150
            }
            else
            {
                return 100
            }
        }
        
        
    }
    
    func tapResponse()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBAction func genderBtnClicked(sender: UIButton)
    {
        if sender.tag == -2
        {
            signupDataDict.setObject("Male", forKey: "gender" as NSCopying)
        }else{
            signupDataDict.setObject("Female", forKey: "gender" as NSCopying)
        }
        let indexPath = IndexPath(row: 4 , section: 0)
        self.tableView?.reloadRows(at: [indexPath], with: .automatic)
    }
    
    @IBAction func currentLoaction(sender: UIButton)
    {
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                supportingfuction.hideProgressHudInView(view: self)
                supportingfuction.showMessageHudWithMessage(message: "Something went wrong.Please try again later.", delay: 2.0)
                return
                
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                for likelihood in placeLikelihoodList.likelihoods {
                    supportingfuction.hideProgressHudInView(view: self)
                    let place = likelihood.place
                    
                    if (place.formattedAddress) != nil
                    {
                        self.signupDataDict.setObject((place.formattedAddress)!, forKey: "address" as NSCopying)
                    }
                    
                    print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                    print("Current Place address \(place.formattedAddress)")
                    print("Current Place attributions \(place.attributions)")
                    print("Current PlaceID \(place.placeID)")
                    self.tableView?.reloadData()
                }
                supportingfuction.hideProgressHudInView(view: self)
            }
        })
    }
    
    
    @IBAction func SubmitBtnTapped(sender: UIButton){
        self.view.endEditing(true)
        
        if signupDataDict.object(forKey: "first_name") == nil ||  signupDataDict.object(forKey: "first_name") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: enterFirstName as NSString, delay: 2.0)
            return
        }
        if signupDataDict.object(forKey: "last_name") == nil ||  signupDataDict.object(forKey: "last_name") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: enterLastName as NSString, delay: 2.0)
            return
        }
        if signupDataDict.object(forKey: "date_of_birth") == nil ||  signupDataDict.object(forKey: "date_of_birth") as! String == ""
        {
            
            supportingfuction.showMessageHudWithMessage(message: enterDob as NSString, delay: 2.0)
            return
            
        }
        if signupDataDict.object(forKey: "gender") == nil ||  signupDataDict.object(forKey: "gender") as! String == ""
        {
            
            supportingfuction.showMessageHudWithMessage(message: gender as NSString, delay: 2.0)
            return
        }
        if signupDataDict.object(forKey: "email") == nil ||  signupDataDict.object(forKey: "email") as! String == ""
        {
            
            supportingfuction.showMessageHudWithMessage(message: "Please enter email address." as NSString, delay: 2.0)
            return
        }
        
        
        if (CommonValidations.isValidEmail(testStr: signupDataDict.object(forKey: "email") as! String ) ) == false
        {
            supportingfuction.showMessageHudWithMessage(message: validEmail as NSString, delay: 2.0)
            return
        }
        
        
        if signupDataDict.object(forKey: "mobile_number") == nil ||  signupDataDict.object(forKey: "mobile_number") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: enterMobileNum as NSString, delay: 2.0)
            return
        }
        
        if  (signupDataDict.object(forKey: "mobile_number") as! String).characters.count  <= 5 ||   (signupDataDict.object(forKey: "mobile_number") as! String).characters.count > 15
        {
            
            supportingfuction.showMessageHudWithMessage(message: "Mobile Number field must contain 6 to 15 digits.", delay: 2.0)
            return
        }
        
        if signupDataDict.object(forKey: "address") == nil || signupDataDict.object(forKey: "address") as! String == ""
        {
            
            supportingfuction.showMessageHudWithMessage(message: "Please select address." as NSString, delay: 2.0)
            return
            
        }
        if signupDataDict.object(forKey: "street_name") == nil ||  signupDataDict.object(forKey: "street_name") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: "Please enter street address.", delay: 2.0)
            return
            
        }
        
        //                if  (isvalidIdentity(IdentityStr: signupDataDict.object(forKey: "registration") as! String ) ) == false
        //                {
        //                    supportingfuction.showMessageHudWithMessage(message: "Registration Number - Only 7 characters are allowed. First letter should be M, followed by 5 digit number and last letter should be A-Z.", delay: 3.0)
        //                    return
        //                }
        
        if signupDataDict.object(forKey: "city") == nil ||  signupDataDict.object(forKey: "city") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: "Please enter city." as NSString, delay: 2.0)
            return
        }
        
        //        state
        if signupDataDict.object(forKey: "state") == nil ||  signupDataDict.object(forKey: "state") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: "Please enter location." as NSString, delay: 2.0)
            return
        }
        
        if signupDataDict.object(forKey: "area_code") == nil ||  signupDataDict.object(forKey: "area_code") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: "Please enter area code." as NSString, delay: 2.0)
            return
        }
        
        if signupDataDict.object(forKey: "country") == nil ||  signupDataDict.object(forKey: "country") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: "Please select country." as NSString, delay: 2.0)
            return
        }
        
        
        if signupDataDict.object(forKey: "occupation") == nil ||  signupDataDict.object(forKey: "occupation") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: "Please enter Occupation." as NSString, delay: 2.0)
            return
        }
        
        if signupDataDict.object(forKey: "language_id") == nil ||  signupDataDict.object(forKey: "language_id") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: "Please select Language." as NSString, delay: 2.0)
            return
        }
        
        //maritualstatus
        
        
        if signupDataDict.object(forKey: "maritualstatus") == nil ||  signupDataDict.object(forKey: "maritualstatus") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: "Please select Maritual Status." as NSString, delay: 2.0)
            return
        }
        
        //signupDataDict.setObject("selected", forKey: "t&c" as NSCopying)
        
        
        print("All validation pass")
        if(!appDelegate.hasConnectivity())
        {
            supportingfuction.showMessageHudWithMessage(message: NoInternetConnection as NSString, delay: 2.0)
        }
        else
        {
            signupWebService()
        }
        
        
    }
    
    func validationForPassword() -> Bool
    {
        if signupDataDict.object(forKey: "password") as? String != nil && signupDataDict.object(forKey: "password") as! String != ""
        {
            let passwordTrimmedString = (signupDataDict.object(forKey: "password") as! String).trimmingCharacters(in: CharacterSet.whitespaces)
            
            if(!CommonValidations.isValidPassword(testStr: passwordTrimmedString))
            {
                supportingfuction.showMessageHudWithMessage(message: validPassword as NSString, delay: 2.0)
                
                return false
            }else  if signupDataDict.object(forKey: "match_password") as? String != nil && signupDataDict.object(forKey: "match_password") as! String != ""
            {
                let passwordTrimmedString = (signupDataDict.object(forKey: "match_password") as! String).trimmingCharacters(in: CharacterSet.whitespaces)
                
                if(!CommonValidations.isValidPassword(testStr: passwordTrimmedString))
                {
                    supportingfuction.showMessageHudWithMessage(message: validPassword as NSString, delay: 2.0)
                    
                    return false
                }
                
            }
            
            
        }
        
        return true
    }
    
    
    
    
    @IBAction func addMoreBtnTapped(sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddChildViewController") as! AddChildViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func changePasswordBtnTapped(sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func deleteChildWebMethod(sender: UIButton)
    {
        
        let alertView = UIAlertController(title: "", message: "Are you sure you want to delete this child from list?", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alertView.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alertAction) -> Void in
            // self.favUnfav(sender: sender)
            
            self.deleteWebService(sender: sender)
            
        }))
        present(alertView, animated: true, completion: nil)
        
        
    }
    
    func deleteWebService(sender: UIButton) {
        
        
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView?.indexPathForRow(at: pointInTable)
        print(cellIndexPath!)
        
        
        
        let dict = NSMutableDictionary()
        
        dict.setObject(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id" as NSCopying)
        
        if let x  = ((childDataArray.object(at: cellIndexPath![1] - 1) as! NSDictionary).object(forKey: "id_child") as? String)
        {
            dict.setObject(x, forKey: "child_id" as NSCopying)
        }
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        
        let apiSniper = APISniper()
        
        
        apiSniper.getDataFromWebAPI(WebAPI.delete_child,dict, {(operation, responseObject) in
            
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
                        
                        
                        self.childDataArray.removeObject(at: cellIndexPath![1] - 1)
                        self.tableView?.reloadData()
                        
                        supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                        
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
    
    // MARK: - picking image
    @IBAction func imagePickerBtn(_ sender: UIButton) {
        
        let myActionSheet : UIActionSheet  = UIActionSheet()
        myActionSheet.addButton(withTitle: "Use Gallery")
        myActionSheet.addButton(withTitle: "Use Camera")
        myActionSheet.addButton(withTitle: "Cancel")
        myActionSheet.delegate=self
        
        
        myActionSheet.show(in: self.view)
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        print(buttonIndex)
        switch(buttonIndex)
        {
            
        case 0:
            Picker.allowsEditing = false
            Picker.sourceType = .photoLibrary
            self.present(Picker, animated: true, completion: nil)
            Picker.delegate = self
            break
            
        case 1:
            Picker.allowsEditing = false
            Picker.sourceType = UIImagePickerControllerSourceType.camera
            present(Picker, animated: true, completion: nil)
            Picker.delegate = self
            break
            
        default:break
        }
    }
    //opengallery
    func openGallery()
    {
        //Picker.delegate = self
        Picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(Picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            galleryImage = pickedImage
            //  galleryImage = croppedImage
            
            //            self.signupDataDict.setObject(galleryImage, forKey: "image" as NSCopying)
            //             imageData = UIImageJPEGRepresentation(pickedImage, 0.6) as! NSData
            //            self.tableView?.reloadData()
        }
        picker.dismiss(animated: true) { () -> Void in
            self.openEditor() // uncomment it make cropper inable thanks.
        }
        dismiss(animated: true, completion: nil)
    }
    
    // croping functionality
    func openEditor()
    {
        let controller=PECropViewController()
        controller.delegate = self;
        controller.image = galleryImage
        let image1 = galleryImage
        let width : CGFloat = (image1.size.width)
        let height : CGFloat = (image1.size.height)
        let length : CGFloat = min(width, height)
        controller.imageCropRect = CGRect(x: (width - length) / 2, y: (height - length) / 2, width: length, height: length)
        let navigationController=UINavigationController(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func cropViewController(_ controller: PECropViewController!, didFinishCroppingImage croppedImage: UIImage!, transform: CGAffineTransform, cropRect: CGRect)
    {
        controller.dismiss(animated: true, completion: nil)
        //edited = true
        galleryImage = croppedImage
        self.signupDataDict.setObject(croppedImage, forKey: "image" as NSCopying)
        imageData = UIImageJPEGRepresentation(croppedImage, 0.6)! as NSData
        imageEdited = true
        self.tableView?.reloadData()
    }
    
    func cropViewControllerDidCancel(_ controller: PECropViewController!)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    // date picker
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
            signupDataDict.setObject((date.string(from: datePicker.date) ), forKey: "date_of_birth" as NSCopying)
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
    
    
    func getChildArray(childArray: NSMutableArray)
    {
        if var x = childArray as? NSMutableArray
        {
            childDataArray = childArray
        }
        tableView?.reloadData()
    }
    
    
    // get country code
    func getCountryCode(code: String, ID: String)
    {
        if dropDownFor == "langauge"
        {
            signupDataDict.setObject(ID, forKey: "language_id" as NSCopying)
            signupDataDict.setObject(code, forKey: "language" as NSCopying)
        }
        else if dropDownFor == "maritualstatus"
        {
            signupDataDict.setObject(code, forKey: "maritualstatus" as NSCopying)
        }
        else
        {
            signupDataDict.setObject(ID, forKey: "mobile_ext" as NSCopying)
            signupDataDict.setObject(code, forKey: "country" as NSCopying)
        }
        
        
        self.tableView?.reloadData()
    }
    
    func signupWebService()
    {
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        //user_id
        
        dict.setObject(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id" as NSCopying)
        dict.setObject(signupDataDict.object(forKey: "first_name") as! String, forKey: "first_name" as NSCopying)
        dict.setObject(signupDataDict.object(forKey: "last_name") as! String, forKey: "last_name" as NSCopying)
        dict.setObject(signupDataDict.object(forKey: "date_of_birth") as! String, forKey: "date_of_birth" as NSCopying)
        dict.setObject(signupDataDict.object(forKey: "email") as! String, forKey: "email" as NSCopying)
        dict.setObject(signupDataDict.object(forKey: "mobile_number") as! String, forKey: "mobile_number" as NSCopying)
        dict.setObject(signupDataDict.object(forKey: "address") as! String, forKey: "address" as NSCopying)
        dict.setObject(signupDataDict.object(forKey: "street_name") as! String, forKey: "street_address" as NSCopying)
        dict.setObject(signupDataDict.object(forKey: "city") as! String, forKey: "city" as NSCopying)
        dict.setObject(signupDataDict.object(forKey: "state") as! String, forKey: "state" as NSCopying)
        dict.setObject(signupDataDict.object(forKey: "area_code") as! String, forKey: "area_code" as NSCopying)
        dict.setObject(signupDataDict.object(forKey: "country") as! String, forKey: "country" as NSCopying)
        
        dict.setObject(signupDataDict.object(forKey: "mobile_ext") as! String, forKey: "mobile_ext" as NSCopying)
        dict.setObject(signupDataDict.object(forKey: "gender") as! String, forKey: "gender" as NSCopying)
        
        dict.setObject(signupDataDict.object(forKey: "language_id") as! String, forKey: "language_id" as NSCopying)
        
        dict.setObject(signupDataDict.object(forKey: "occupation") as! String, forKey: "occupation" as NSCopying)
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        dict.setObject(signupDataDict.object(forKey: "maritualstatus") as! String, forKey: "maritualstatus" as NSCopying)
        //occupation
        
        dict.setObject("patient", forKey: "user_type" as NSCopying)
        let apiSniper = APISniper()
        apiSniper.uploadImages(WebAPI.edit_profile,dict, imageData, completeBlock: {(operation, responseObject) in
            supportingfuction.hideProgressHudInView(view: self)
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    if dataFromServer.object(forKey: "message") != nil
                    {
                        
                        UserDefaults.standard.set(dataFromServer.object(forKey: "data"), forKey: "user_detail")
                        UserDefaults.standard.synchronize()
                        
                        self.navigationController?.popViewController(animated: true)
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
                        supportingfuction.hideProgressHudInView(view: self)
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
extension EditProfileViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        
        print("Place address: \(place.formattedAddress)")
        
        if (place.formattedAddress) != nil
        {
            self.signupDataDict.setObject((place.formattedAddress)!, forKey: "address" as NSCopying)
        }
        
        
        
        print("Place attributions: \(place.attributions)")
        print("Place latitude: \(place.coordinate.latitude)")
        print("Place longitude: \(place.coordinate.longitude)")
        
        dismiss(animated: true, completion: nil)
        self.tableView?.reloadData()
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
extension EditProfileViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    
}
