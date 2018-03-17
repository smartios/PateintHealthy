//
//  FamilyHistoryViewController.swift
//  QuickHealthPatient
//
//  Created by mac  on 15/01/18.
//  Copyright © 2018 SL161. All rights reserved.
//

import UIKit

class FamilyHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var from = ""
    var familyHistoryArr = NSMutableArray()
    var id_appointment = ""
    
    @IBOutlet var headerVw: UIView!
    @IBOutlet var noRecordLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        noRecordLbl.isHidden = true
        headerVw.isHidden = false

        self.familyHistory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - uitableview dlegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return familyHistoryArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
       
            cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
            let lbl1 = cell.viewWithTag(1) as! UILabel
            let lbl2 = cell.viewWithTag(2) as! UILabel
        lbl1.text = (self.familyHistoryArr.object(at: indexPath.row) as! NSDictionary).object(forKey: "diseases_name") != nil ? (self.familyHistoryArr.object(at: indexPath.row) as! NSDictionary).object(forKey: "diseases_name") as! String : ""
        lbl2.text = (self.familyHistoryArr.object(at: indexPath.row) as! NSDictionary).object(forKey: "to_whom") != nil ? (self.familyHistoryArr.object(at: indexPath.row) as! NSDictionary).object(forKey: "to_whom") as! String : ""
            
        return cell
    }

    
    @IBAction func backBtnTapper(sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Web Service Implementation
    
    func familyHistory()->Void
    {
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        // dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        if from == "userScreen"
        {
            dict.setObject(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id" as NSCopying)
        }
        else{
            dict.setObject(id_appointment, forKey: "id_appointment" as NSCopying)
        }
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPI(WebAPI.family_history,dict, {(operation, responseObject) in
            if let dataFromServer = responseObject as? NSDictionary
            {
                supportingfuction.hideProgressHudInView(view: self)
                if dataFromServer.object(forKey: "status") as! String == "success"
                {
                    
                    self.familyHistoryArr = dataFromServer.object(forKey: "data") != nil && dataFromServer.object(forKey: "data") is NSArray ? (dataFromServer.object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray : NSMutableArray()
                    
                        self.tableView?.reloadData()
                    
                    if self.familyHistoryArr.count == 0
                    {
                        self.noRecordLbl.isHidden = false
                        self.headerVw.isHidden = true
                    }
                }
                else if(dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                   
                    logoutUser()
                }
                else{
//                    supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                    
                    self.noRecordLbl.isHidden = false
                    self.headerVw.isHidden = true

                }
                }
        }) { (operation, error) in
            // print(error.localizedDescription)
            supportingfuction.hideProgressHudInView(view: self)
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        }
    }

}
