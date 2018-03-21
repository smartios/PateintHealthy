//
//  ProvidedServicesViewController.swift
//  QuickHealthPatient
//
//  Created by SL161 on 08/11/17.
//  Copyright © 2017 SL161. All rights reserved.
//

import UIKit

class ProvidedServicesViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
 var window: UIWindow?
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var headerView: UIView!
    
     var dataArray = NSMutableArray()
    var screenSize = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          NotificationCenter.default.addObserver(self, selector: #selector(ProvidedServicesViewController.moveTotab4), name: NSNotification.Name(rawValue: "moveTotab4"), object: nil)
        
        borderShadow()
        //tabBarController?.selectedIndex = 0
        // self.tabBarController?.tabBar.items?[0].isEnabled = false
//         self.tabBarController?.tabBar.items?[2].isEnabled = false
//         self.tabBarController?.tabBar.items?[3].isEnabled = false
       // tabBarController?.selectedIndex = 1;
        // Do any additional setup after loading the view.
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(UserDefaults.standard.value(forKey: "user_detail") != nil)
        {
            serviceListWebService()
        }
        
        UIApplication.shared.statusBarView?.backgroundColor = .white
    }
    
    // MARK: - To make shadow at bottom view
    
    func moveTotab4()
    {
       tabBarController?.selectedIndex = 3
        
        (tabBarController?.viewControllers![3] as! AppointmentListViewController).appointment_list()
    }
    
    
    func borderShadow()
    {
        headerView.layer.masksToBounds = false
        headerView.layer.shadowColor = UIColor.gray.cgColor
        headerView.layer.shadowOffset = CGSize.zero
        headerView.layer.shadowOpacity = 0.5
        headerView.layer.shadowRadius = 1.0
        headerView.layer.shadowPath = UIBezierPath(rect:CGRect(x: 0, y: 63, width: screenSize.width, height: 1)).cgPath
    }
    
    // MARK: - UICollectionView Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell:UICollectionViewCell!
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        
        
        let imageview = cell.viewWithTag(1) as! UIImageView
        let nameLabel = cell.viewWithTag(2) as! UILabel
       // let labelView = cell.viewWithTag(3)! as!
        
        imageview.layer.borderWidth = 3.5
        imageview.layer.borderColor = UIColor.white.cgColor
        //labelView.addGradientLayerToView(colors: [UIColor.green.cgColor])
        
        nameLabel.font = UIFont(name: "OpenSans-Bold", size: 12.0)
        
        let dict = dataArray.object(at: indexPath.row) as! NSDictionary
        
        nameLabel.text = dict.object(forKey: "service_title") != nil && dict.object(forKey: "service_title") is NSString ? "\(dict.object(forKey: "service_title")as! String)" : ""
       
        if dict.object(forKey: "service_image") != nil && dict.object(forKey: "service_image") is NSString
        {
        imageview.setImageWith(URL(string: dict.object(forKey: "service_image")as! String)!)
        }
        else
        {
            imageview.image = #imageLiteral(resourceName: "serviceList_background")
        }
//        if indexPath.row == self.dataArray.count - 1
//        {
//            if (self.dataArray.count)%10 == 0
//            {
//                page = (self.dataArray.count)/10 - 1
//                page = page + 1
//                self.upcomigWeddingWebService()
//            }
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      let vc = UIStoryboard(name: "TabbarStoryboard", bundle: nil).instantiateViewController(withIdentifier: "AvailableDoctorsViewController") as! AvailableDoctorsViewController
        vc.ApptSend_serviceID = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UICollectionViewFlowLayout Delegates
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var height:CGSize
        height =  CGSize(width:((screenSize.width - 45)/2), height: ((collectionView.frame.size.height - 45)/3))
        return height
    }
    
    
    //MARK:- Action Method
    
    /// When user clicks on the button - Side Menu will be opened.
    ///
    /// - Parameter sender: UIButton
    @IBAction func menuButtonClicked(sender: AnyObject) {
        onSlideMenuButtonPressed(sender as! UIButton)
    }
    
    
    // MARK: - Webservice Method
    
    /// Function to get list of all services from the server.
    func serviceListWebService()
    {
        supportingfuction.hideProgressHudInView(view: self)
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        let params = NSMutableDictionary()
        params.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        
        let apiSniper = APISniper()
        
        apiSniper.getDataFromWebAPI(WebAPI.services_list, params ,{(operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                        self.dataArray = (dataFromServer.object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
                    self.collectionView.reloadData()
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

