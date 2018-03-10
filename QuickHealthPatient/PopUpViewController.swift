//
//  PopUpViewController.swift
//  QuickHealthPatient
//
//  Created by SL161 on 09/11/17.
//  Copyright © 2017 SL161. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    
   @IBOutlet weak var image = UIImageView()
    @IBOutlet weak var titleText: UILabel?
    @IBOutlet weak var descriptionText: UILabel?
    @IBOutlet weak var myView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor.clear
//        view.isOpaque = false
        myView?.layer.cornerRadius = 15;
        myView?.layer.masksToBounds = true
        titleText?.text = "Congratulations!"
        descriptionText?.text = "You have successful registered. You can now book your appoints"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissBtnTAppde(_ sender: Any) {
       
        
        self.dismiss(animated: false, completion: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "popToRootView"), object: nil)
        })
        
      //   self.dismiss(animated: false, completion: nil)
       

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
