//
//  RatingViewController.swift
//  QuickHealthPatient
//
//  Created by singsys on 2/3/18.
//  Copyright © 2018 SL161. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITextViewDelegate, FloatRatingViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerCell: UITableViewCell!
    @IBOutlet var titleCell: UITableViewCell!
    @IBOutlet var reviewCell: UITableViewCell!
    @IBOutlet var buttonCell: UITableViewCell!
    @IBOutlet var ratingCell: UITableViewCell!
    var from = ""
    
    var rateValue :Float = 0
    var keyboardHeight = CGFloat()
    var tapGesture = UITapGestureRecognizer()
    var dataDict = NSMutableDictionary()
    
    //    MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(UserDefaults.standard.value(forKey: "ongoing_id_appointment") != nil)
        {
            dataDict.setValue("\(UserDefaults.standard.value(forKey: "ongoing_id_appointment")!)", forKey: "ongoing_id_appointment")
            UserDefaults.standard.removeObject(forKey: "ongoing_id_appointment")
        }
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tableView.addGestureRecognizer(tapGesture)
        tableView.layer.cornerRadius = 12
        // Do any additional setup after loading the view.
    }
    
    
    func remove_rating_screen()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(remove_rating_screen), name: NSNotification.Name(rawValue: "remove_rating_screen"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(NSNotification.Name.UIKeyboardWillHide)
        NotificationCenter.default.removeObserver(NSNotification.Name.UIKeyboardWillShow)
        if(from == "nurse")
        {
            NotificationCenter.default.removeObserver("remove_rating_screen")
        }
        
    }
    
    //    MARK: - TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        Bundle.main.loadNibNamed("RateCells", owner: self, options: nil)
        
        var cell:UITableViewCell!
        
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
            if cell == nil
            {
                cell = headerCell
                headerCell = nil
            }
            //        let headerLabel = cell.viewWithTag(1) as! UILabel
            //        let textLabel = cell.viewWithTag(2) as! UILabel
        }
        else if indexPath.row == 1 || indexPath.row == 3
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "titleCell")
            if cell == nil
            {
                cell = titleCell
                titleCell = nil
            }
            let titleLabel = cell.viewWithTag(1) as! UILabel
            if indexPath.row == 1
            {
                if(from == "nurse")
                {
                     titleLabel.text = "Rate Nurse"
                }
                else
                {
                     titleLabel.text = "Rate Doctor"
                }
               
            }
            else if indexPath.row == 3
            {
                titleLabel.text = "Review"
            }
        }
        else if indexPath.row == 4
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell")
            if cell == nil
            {
                cell = reviewCell
                reviewCell = nil
            }
            let textView = cell.viewWithTag(1) as! UITextView
            
            textView.delegate = self
            textView.keyboardType = .default
            textView.layer.borderColor = UIColor.lightGray.cgColor
            textView.layer.borderWidth = 1.0
            if dataDict.object(forKey: "review") != nil && dataDict.object(forKey: "review") as! String != ""
            {
                textView.text = "\(dataDict.object(forKey: "review")!)"
                textView.textColor = CommonValidations.UIColorFromRGB(rgbValue: 000000)
            }
            else
            {
                textView.text = "Write a review..."
                textView.textColor = CommonValidations.UIColorFromRGB(rgbValue: 999999)
            }
        }
        else if indexPath.row == 5
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")
            if cell == nil
            {
                cell = buttonCell
                buttonCell = nil
            }
            let button = cell.viewWithTag(1) as! UIButton
            button.layer.cornerRadius = 4.0
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "ratingCell")
            if cell == nil{
                cell = ratingCell
                ratingCell = nil
            }
            let collectionView = cell.viewWithTag(1) as! UICollectionView
            
            collectionView.register(UINib(nibName: "rateCollectionCells", bundle: nil), forCellWithReuseIdentifier: "rateCollectionCell")
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.reloadData()
            cell.layoutIfNeeded()
            for constrints in (collectionView.constraints){
                if constrints.identifier == "collectHeight"{
                    
                    constrints.constant =  215//((collectionView.frame.size.width-40)/2) * 2 + 35
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row != 0 && indexPath.row != 1 && indexPath.row != 3 && indexPath.row != 4 && indexPath.row != 5  {
//
//            let screenSize = UIScreen.main.bounds.size
//
//            return (((screenSize.width - 140)/2)+20) * 3
//        }
        return UITableViewAutomaticDimension
    }
    
    //    MARK: - CollectionView Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        Bundle.main.loadNibNamed("rateCollectionCells", owner: self, options: nil)
        
        var cell:UICollectionViewCell!
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rateCollectionCell", for: indexPath)
        
        let levelLabel = cell.viewWithTag(1) as! UILabel
        //        let ratingLabel = cell.viewWithTag(2) as! UILabel
        let floatRatingView = cell.viewWithTag(3) as! FloatRatingView
        
        floatRatingView.emptyImage = #imageLiteral(resourceName: "StarGrey")
        floatRatingView.fullImage = #imageLiteral(resourceName: "StarOrange")
        // Optional params
        
        floatRatingView.delegate = self
        floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        floatRatingView.maxRating = 5
        floatRatingView.minRating = 0
        floatRatingView.rating = 0
        floatRatingView.editable = true
        floatRatingView.halfRatings = true
        floatRatingView.floatRatings = false
        
        if indexPath.row == 0
        {
            levelLabel.text = "Knowledge"
            floatRatingView.accessibilityHint = "1"
        }
        else if indexPath.row == 1
        {
            levelLabel.text = "Helpfulness"
            floatRatingView.accessibilityHint = "2"
        }
        else if indexPath.row == 2
        {
            levelLabel.text = "Punctuality"
            floatRatingView.accessibilityHint = "3"
        }
        else if indexPath.row == 3
        {
            levelLabel.text = "Manners"
            floatRatingView.accessibilityHint = "4"
        }
        else if indexPath.row == 4
        {
            levelLabel.text = "Politeness"
            floatRatingView.accessibilityHint = "5"
        }
        
        levelLabel.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    
    // MARK: - UICollectionViewFlowLayout Delegates
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var height = CGSize()
        let screenSize = UIScreen.main.bounds.size
        
        height =  CGSize(width:((screenSize.width - 140)/2), height: 58)
        return height
    }
    
    
    //MARK:- TextView Delegates
    
    
    //    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    //        return true
    //    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == CommonValidations.UIColorFromRGB(rgbValue: 999999)
        {
            textView.text = nil
            textView.textColor = CommonValidations.UIColorFromRGB(rgbValue: 000000)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write a review..."
            textView.textColor = CommonValidations.UIColorFromRGB(rgbValue: 999999)
        }
        dataDict.setObject(textView.text!, forKey: "remarks" as NSCopying)
    }
    
    
    //MARK:- Keyboard Handling Methods
    
    /// Notification function called whenever keyboard is revealed.
    ///
    /// - Parameter notification: Notification
    @objc func keyboardWillShow(_ notification: Notification)
    {
        
        if let userInfo = (notification as NSNotification).userInfo
        {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                tableView.contentInset = contentInsets
                tableView.scrollIndicatorInsets = contentInsets
                // ...
            } else {
                // no UIKeyboardFrameEndUserInfoKey entry in userInfo
            }
        } else {
            // no userInfo dictionary in notification
        }
        
    }
    
    /// Notification function called whenever keyboard is dismissed.
    ///
    /// - Parameter notification: notification.
    @objc func keyboardWillHide(_ notification: Notification)
    {
        let contentInsets = UIEdgeInsets.zero as UIEdgeInsets
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
        
    }
    
    /// Hide keyboard when user taps anywhere on the screen.
    @objc func hideKeyboard()
    {
        self.view.endEditing(true)
    }
    
    // MARK:- FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float)
    {
        // self.liveLabel.text = NSString(format: "%.f", self.floatRatingView.rating) as String
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float)
    {
        //  self.updatedLabel.text = NSString(format: "%.f", self.floatRatingView.rating) as String
        
        if(ratingView.accessibilityHint == "1")
        {
            dataDict.setValue("\(rating)", forKey: "Knowledge")
        }
        else if(ratingView.accessibilityHint == "2")
        {
            dataDict.setValue("\(rating)", forKey: "Helpfulness")
        }
        else if(ratingView.accessibilityHint == "3")
        {
            dataDict.setValue("\(rating)", forKey: "Punctuality")
        }
        else if(ratingView.accessibilityHint == "4")
        {
            dataDict.setValue("\(rating)", forKey: "Manners")
        }
        else if(ratingView.accessibilityHint == "5")
        {
            dataDict.setValue("\(rating)", forKey: "Politeness")
        }
    }
    
    
    //MARK:- Action Method
    
    /// When button pressed - To submit rating.
    ///
    /// - Parameter sender: UIButton
    @IBAction func submitButtonClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.rating_webservice()
        
        // self.dismiss(animated: true, completion: nil)
    }
    
    func rating_webservice()
    {
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        let dict = NSMutableDictionary()
        dict.setObject("\(from)", forKey: "user_type" as NSCopying)
        
        if(dataDict.value(forKey: "remarks") != nil)
        {
            dict.setValue("\(dataDict.value(forKey: "remarks")!)", forKey: "remarks")
        }
        else
        {
            dict.setValue("", forKey: "remarks")
        }
        
        let array = NSMutableArray()
        let dic = NSMutableDictionary()
        
        //for knowledge
        dic.setValue("Knowledge", forKey: "scope")
        if(dataDict.value(forKey: "Knowledge") != nil)
        {
            dic.setValue("\(dataDict.value(forKey: "Knowledge")!)", forKey: "rating")
        }
        else
        {
            dic.setValue("0", forKey: "rating")
        }
        array.add(dic)
        
        //for Helpfulness
        if(dataDict.value(forKey: "Helpfulness") != nil)
        {
            dic.setValue("\(dataDict.value(forKey: "Helpfulness")!)", forKey: "rating")
        }
        else
        {
            dic.setValue("0", forKey: "rating")
        }
        array.add(dic)
        
        //for Punctuality
        if(dataDict.value(forKey: "Punctuality") != nil)
        {
            dic.setValue("\(dataDict.value(forKey: "Punctuality")!)", forKey: "rating")
        }
        else
        {
            dic.setValue("0", forKey: "rating")
        }
        array.add(dic)
        
        //for Manners
        if(dataDict.value(forKey: "Manners") != nil)
        {
            dic.setValue("\(dataDict.value(forKey: "Manners")!)", forKey: "rating")
        }
        else
        {
            dic.setValue("0", forKey: "rating")
        }
        array.add(dic)
        
        //for Politeness
        if(dataDict.value(forKey: "Politeness") != nil)
        {
            dic.setValue("\(dataDict.value(forKey: "Politeness")!)", forKey: "rating")
        }
        else
        {
            dic.setValue("0", forKey: "rating")
        }
        array.add(dic)
        
        dict.setValue(array, forKey: "rating_data")
        dict.setValue("\(dataDict.value(forKey: "ongoing_id_appointment")!)", forKey: "id_appointment")
        
        let apiSniper = APISniper()
        
        
        apiSniper.getDataFromWebAPI(WebAPI.Feedback_Rating,dict, {(operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    if(self.from == "doctor")
                    {
                        
                        self.from = "nurse"
                        let id = "\(self.dataDict.value(forKey: "ongoing_id_appointment")!)"
                        self.dataDict.removeAllObjects()
                        self.dataDict.setValue("\(id)", forKey: "ongoing_id_appointment")
                        self.tableView.reloadData()
                          supportingfuction.showMessageHudWithMessage(message: "Please rate nurse.", delay: 2.0)
//                        let vc = RatingViewController(nibName: "RatingViewController", bundle: nil)
//                        vc.from = "nurse"
//
//                        vc.dataDict.setValue("\(self.dataDict.value(forKey: "ongoing_id_appointment")!)", forKey: "ongoing_id_appointment")
//                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else
                    {
                        if dataFromServer.object(forKey: "message") != nil
                        {
                            supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                        }
                        self.navigationController?.popViewController(animated: true)
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


