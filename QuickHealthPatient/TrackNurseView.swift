//
//  TrackNurseView.swift
//  QuickHealthDoctorApp
//
//  Created by SS042 on 23/01/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit
import CoreLocation

class TrackNurseView: UIView {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userID: UILabel!
    @IBOutlet var appointmentDate: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var appointmentTime: UILabel!
    
    var userTrackData = TrackNurse(){
        didSet{
            self.refreshData()
        }
    }
    
    func refreshData(){
        if userTrackData.userImage != ""{
            self.userImage.setImageWith(URL(string: userTrackData.userImage)!, placeholderImage: UIImage(named:""))
        }
        self.address.text = userTrackData.address
        self.appointmentDate.text = userTrackData.appointmentDate
        self.appointmentTime.text = userTrackData.appointmentTime
        self.userName.text = userTrackData.userName
        self.userID.text = userTrackData.userID
    }
    
    @IBAction func detailBtnClicked(_ sender: UIButton) {
        let vc = UIStoryboard(name: "TabbarStoryboard", bundle: nil).instantiateViewController(withIdentifier: "DoctorsProfileViewController") as! DoctorsProfileViewController
        vc.docId = "\(userTrackData.user_id!)"
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
}

struct TrackNurse{
    var userImage:String!
    var userName:String!
    var userID:String!
    var appointmentDate:String!
    var address:String!
    var appointmentTime:String!
    var cordinates:CLLocationCoordinate2D!
    var user_id:String!
    
    init(json:NSDictionary){
        
        if(json.count > 0)
        {
            
            userImage = "\((json.value(forKey: "nurse_details") as! NSDictionary).value(forKey: "user_image")!)"
            userName = "\((json.value(forKey: "nurse_details") as! NSDictionary).value(forKey: "first_name")!) \((json.value(forKey: "nurse_details") as! NSDictionary).value(forKey: "last_name")!)"
            userID = "ID-\((json.value(forKey: "nurse_details") as! NSDictionary).value(forKey: "unique_number")!)"
            user_id = "\((json.value(forKey: "nurse_details") as! NSDictionary).value(forKey: "id_user")!)"
            
            appointmentDate =  CommonValidations.getDateStringFromDateString(date: "\(json.value(forKey: "available_date")!)", fromDateString: "yyyy-MM-dd", toDateString: "dd MMM yyyy")
            address = "\((json.value(forKey: "nurse_details") as! NSDictionary).value(forKey: "address")!)"
           appointmentTime = CommonValidations.getDateStringFromDateString(date: "\(json.value(forKey: "start_time")!)", fromDateString: "HH:mm:ss", toDateString: "hh:mm a")
            //
            let lat = Double("\(((json.value(forKey: "nurse_details") as! NSDictionary).value(forKey: "nurse_location") as! NSDictionary).value(forKey: "latitude")!)")
            let lon = Double("\(((json.value(forKey: "nurse_details") as! NSDictionary).value(forKey: "nurse_location") as! NSDictionary).value(forKey: "longitude")!)")
            cordinates = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
        }
    }
    
    init() {
        userImage = ""
        userName = "N/A"
        userID = "N/A"
        appointmentDate = "N/A"
        address = "N/A"
        appointmentTime = "N/A"
        cordinates = CLLocationCoordinate2D(latitude: 26.846694, longitude: 83.946166)
    }
}
