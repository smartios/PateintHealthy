//
//  MyProfileViewController.swift
//  QuickHealthPatient
//
//  Created by mac  on 13/12/17.
//  Copyright © 2017 SL161. All rights reserved.
//


class MyProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var chilListArray = NSMutableArray()
    var userInfoDict = NSMutableDictionary()
    @IBOutlet weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        user_profile()
//        UIApplication.shared.statusBarView?.backgroundColor = .clear
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - table view delegate methods
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("FAQHeader", owner: self, options: nil)?[0] as! UIView
        let bgImage = headerView.viewWithTag(11) as! UIImageView
        let profileImg = headerView.viewWithTag(12) as! UIImageView
        let editImg = headerView.viewWithTag(10) as! UIImageView
        editImg.isHidden = true
        let userName = headerView.viewWithTag(13) as! UILabel
        let idLbl = headerView.viewWithTag(-40) as! UILabel
        
        profileImg.layer.cornerRadius = (profileImg.frame.height)/2
        profileImg.clipsToBounds = true
        headerView.tag = section
        userName.font = UIFont(name: "OpenSans-Bold_0", size: 16)
        
        if let x = (userInfoDict.object(forKey: "user_image") as? String)
        {
            profileImg.setImageWith(NSURL(string: x)! as URL, placeholderImage: UIImage(named: "landing_image"))
        }else
        {
            profileImg.image = #imageLiteral(resourceName: "landing_image")
        }
        
        if let x = ((userInfoDict.object(forKey: "first_name") as? String))?.uppercased()
        {
            if let y = ((userInfoDict.object(forKey: "last_name") as? String))?.uppercased()
            {
                userName.text = x + " " +  y
            }
        }
        
        idLbl.isHidden = false
        
        if let x = (userInfoDict.object(forKey: "unique_number") as? String)
        {
            idLbl.text = "ID-\(x)"
        }
        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (chilListArray.count) + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return UITableViewAutomaticDimension
        }else if indexPath.row == 1
        {
            if chilListArray.count > 0
            {
                return UITableViewAutomaticDimension
            }else
            {
                return 0
            }
        }
        else
        {
            return 100
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
            let teachingLbl = cell.viewWithTag(1) as! UILabel
            let dobLbl = cell.viewWithTag(2) as! UILabel
            let langLbl = cell.viewWithTag(3) as! UILabel
            let emailLbl = cell.viewWithTag(4) as! UILabel
            let phoneLbl = cell.viewWithTag(5) as! UILabel
            //            let addressLbl = cell.viewWithTag(5) as! UILabel
            let genderLbl = cell.viewWithTag(6) as! UILabel
            let ageLbl = cell.viewWithTag(7) as! UILabel
            let maritalStatusLbl = cell.viewWithTag(8) as! UILabel
            let addressLabl = cell.viewWithTag(9) as! UILabel
            let genderImg = cell.viewWithTag(-6) as! UIImageView
            
            
            
            
            if let x = (userInfoDict.object(forKey: "address") as? String)
            {
                addressLabl.text = x
            }else
            {
                addressLabl.text = "NA"
            }
            
            if (userInfoDict.object(forKey: "age") != nil && "\(userInfoDict.object(forKey: "age")!)" != "")
            {
                ageLbl.text = "\(userInfoDict.object(forKey: "age")!) Yrs"
            }else
            {
                ageLbl.text = "NA"
            }
            
            if let x = (userInfoDict.object(forKey: "occupation") as? String)
            {
                if x != ""
                {
                    teachingLbl.text = x
                }else
                {
                    teachingLbl.text = "NA"
                }
                
            }else
            {
                teachingLbl.text = "NA"
            }
            
            if let x = (userInfoDict.object(forKey: "maritualstatus") as? String)
            {
                if x != ""
                {
                    maritalStatusLbl.text = x
                }else
                {
                    maritalStatusLbl.text = "NA"
                }
                
            }else
            {
                maritalStatusLbl.text = "NA"
            }
            
            
            if let x = (userInfoDict.object(forKey: "email") as? String)
            {
                emailLbl.text = x
            }else
            {
                emailLbl.text = "NA"
            }
            
            
            if let x = (userInfoDict.object(forKey: "dob") as? String)
            {
                dobLbl.text = x
            }else
            {
                dobLbl.text = "NA"
            }
            
            
            if let x = (userInfoDict.object(forKey: "language") as? String)
            {
                langLbl.text = x
            }else
            {
                langLbl.text = "NA"
            }
            
            if let x = (userInfoDict.object(forKey: "mobile_ext") as? String)
            {
                if let y = (userInfoDict.object(forKey: "mobile") as? String)
                {
                    phoneLbl.text = x + " " + y
                }
                
            }else
            {
                phoneLbl.text = "NA"
            }
            
            if let x = (userInfoDict.object(forKey: "gender") as? String)
            {
                //                if x.lowercased() == "female"
                //                {
                //                    genderImg.image = #imageLiteral(resourceName: "femalegender")
                //                }else
                //                {
                genderImg.image = #imageLiteral(resourceName: "gender")
                //                }
                genderLbl.text = x.capitalized
            }else
            {
                genderLbl.text = "NA"
            }
        }
        else if indexPath.row == 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell4")
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell3")
            let nameLbl = cell.viewWithTag(1) as! UILabel
            let dobLbl = cell.viewWithTag(2) as! UILabel
            let genderLbl = cell.viewWithTag(3) as! UILabel
            let idLbl = cell.viewWithTag(4) as! UILabel
            let genderImg = cell.viewWithTag(-3) as! UIImageView
            
            if chilListArray.count > 0
            {
                
                
                if let x = ((chilListArray.object(at: indexPath.row - 2) as! NSDictionary).object(forKey: "first_name") as? String)
                {
                    
                    if let y = ((chilListArray.object(at: indexPath.row - 2) as! NSDictionary).object(forKey: "last_name") as? String)
                    {
                        nameLbl.text = x + " " + y
                    }
                    
                }else
                {
                    nameLbl.text = "NA"
                }
                
                if let x = ((chilListArray.object(at: indexPath.row - 2) as! NSDictionary).object(forKey: "gender") as? String)
                {
                    
                    //                    if x.lowercased() == "female"
                    //                    {
                    //                        genderImg.image = #imageLiteral(resourceName: "femalegender")
                    //                    }else
                    //                    {
                    genderImg.image = #imageLiteral(resourceName: "gender")
                    //                    }
                    
                    genderLbl.text = x.capitalized
                }else
                {
                    genderLbl.text = "NA"
                }
                
                if let x = ((chilListArray.object(at: indexPath.row - 2) as! NSDictionary).object(forKey: "dob") as? String)
                {
                    dobLbl.text = x
                }else
                {
                    dobLbl.text = "NA"
                }
                
                
                if let x = ((chilListArray.object(at: indexPath.row - 2) as! NSDictionary).object(forKey: "unique_number") as? String)
                {
                    idLbl.text = "ID- \(x)"
                }else
                {
                    idLbl.text = "NA"
                }
            }
        }
        
        return cell
    }
    
    // MARK: - user_profile
    func user_profile()
    {
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        
        dict.setObject(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id" as NSCopying)
         dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        
        
        apiSniper.getDataFromWebAPI(WebAPI.user_profile,dict, {(operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    if let x = (dataFromServer.object(forKey: "child") as? NSArray)
                    {
                        self.chilListArray = (x.mutableCopy() as! NSMutableArray)
                    }
                    
                    if let x = (dataFromServer.object(forKey: "data") as? NSDictionary)
                    {
                        self.userInfoDict = (x.mutableCopy() as! NSMutableDictionary)
                    }
                    self.tableView?.reloadData()
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
    
    
    
    @IBAction func backBtnTapper(sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func editBtnTapped(sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        vc.signupDataDict = userInfoDict
        vc.childDataArray = chilListArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
