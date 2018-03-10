//(countryListArray.object(at: 0) as! NSDictionary)
//(lldb) po print(countryListArray.object(at: 0).object(forKey: "iso_code") as! String)
//  CountryCodeViewController.swift
//  DAWPatient
//
//  Created by SS043 on 07/02/17.
//  Copyright © 2017 SS043. All rights reserved.
//

import UIKit

//Delegate
protocol fechedchildList {
    func getChildId(code: String ,ID: String)
}


class ChildListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var headingLabel: UILabel?
    var childListArray = NSMutableArray()
    var delegate: fechedchildList!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        headingLabel?.text = "Filter"
       
        
        if(!appDelegate.hasConnectivity())
        {
            supportingfuction.showMessageHudWithMessage(message: NoInternetConnection as NSString, delay: 2.0)
        }
        else
        {
            getChildList()
 
        }
       
      
 
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - backBtnTapped
    @IBAction func backBtnTapped(sender: UIButton){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - tabelView delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if childListArray.count > 0
        {
           return childListArray.count
        }else
        {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
        let countryName = cell.viewWithTag(1) as! UILabel
        let counrtyCode = cell.viewWithTag(2) as! UILabel
        cell.backgroundColor = UIColor.clear
        
        if indexPath.row == 0 || indexPath.row == 1
        {
            countryName.text = childListArray[indexPath.row] as? String
        }else
        {
               if let x = (childListArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "first_name") as? String, let y = (childListArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "last_name") as? String
               {
                countryName.text = x + " " + y
                }else
               {
                countryName.text = ""
            }
        }
        counrtyCode.text = ""
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 || indexPath.row == 1
        {
            if indexPath.row == 0
            {
                delegate.getChildId(code: "Myself",ID: "")
            }else
            {
                delegate.getChildId(code: "All",ID: "")
            }
        }else
        {
            if let x = ((childListArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id_child") as? String)
            {
                delegate.getChildId(code: x, ID: "")
            }else
            {
              delegate.getChildId(code: "", ID:"")
            }
        
    }
        
         self.navigationController?.popViewController(animated: true)
    }

    // MARK: - tableView Delegate methods
    
    //MARK:- Code staticContent Web Method
    func getChildList()
    {
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        let apiSniper = APISniper()
        
        let params = NSMutableDictionary()
        
        params.setObject(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id" as NSCopying)
        params.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        
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
                        
                        self.childListArray.insert("Myself", at: 0)
                        self.self.childListArray.insert("All", at: 1)
                        self.childListArray.addObjects(from: (((dataFromServer).object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray) as! [Any])
                        
                        self.tableView?.reloadData()
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
    
    
    
    
    
   
    
}
