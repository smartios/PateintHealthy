//
//  WaitingRoomViewController.swift
//  QuickHealthDoctorApp
//
//  Created by singsys on 1/24/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

protocol PulsingCallDelegate{
    func endCallClicked()
    func acceptCallClicked()
}

class WaitingRoomViewController: UIViewController {

    @IBOutlet var pictureImg: UIImageView!
    @IBOutlet var centerView: UIView!
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var idLabel : UILabel!
    @IBOutlet var designationLabel : UILabel!
    var dataDict: NSMutableDictionary!
    var audioPlayer:AVAudioPlayer!
    var halo: PulsingHaloLayer  = PulsingHaloLayer()
    var delegate:PulsingCallDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadgif()
        
        if(dataDict.count > 0)
        {
            setValues()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "call_canceled"), object: nil)
    }
    
    
    func setValues()
    {
        //play sound
        let audioFilePath = Bundle.main.path(forResource: "incoming", ofType: "wav")
        if audioFilePath != nil {
            let audioFileUrl = NSURL.fileURL(withPath: audioFilePath!)
            audioPlayer =  try! AVAudioPlayer(contentsOf: audioFileUrl)
            audioPlayer.numberOfLoops = -1
            audioPlayer.play()
        }
        
        pictureImg.contentMode = .scaleToFill
        pictureImg.clipsToBounds = true
        pictureImg.layer.cornerRadius = pictureImg.frame.size.height/2
        pictureImg.setImageWith(URL(string: "\((dataDict.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_image")!)")!, placeholderImage: #imageLiteral(resourceName: "default_profile_image"))
        nameLabel.text = "\((dataDict.value(forKey: "user_detail") as! NSDictionary).value(forKey: "first_name")!) \((dataDict.value(forKey: "user_detail") as! NSDictionary).value(forKey: "last_name")!)"
        idLabel.text = "\((dataDict.value(forKey: "user_detail") as! NSDictionary).value(forKey: "unique_number")!)"
        designationLabel.text = "\((dataDict.value(forKey: "user_detail") as! NSDictionary).value(forKey: "occupation")!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tappedToDismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: PULSING HALO
    func loadgif()
    {
        halo.removeFromSuperlayer()
        
        let layer = PulsingHaloLayer()
        
        self.halo = layer
        
        //pictureImg.setNeedsLayout()
        //pictureImg.layoutIfNeeded()
        
        centerView.setNeedsLayout()
        centerView.layoutIfNeeded()
        
        //self.picView.superview!.layer.insertSublayer(self.halo, below: self.picView.layer)
        
        pictureImg.superview!.layer.insertSublayer(self.halo, below: pictureImg.layer)
        
        halo.haloLayerNumber = 5
        halo.radius = (CGFloat)(pictureImg.frame.size.height)
        halo.animationDuration = 4
        halo.backgroundColor = UIColor.gray.cgColor
        halo.borderWidth = 1.0
        halo.borderColor = UIColor.gray.cgColor
        
        halo.position = pictureImg.center
        
        //self.picView.layer.addSublayer(self.centerView.layer)
        halo.start()
    }

    //MARK: Action Method
    @IBAction func declineCall (_ sender: UIButton)
    {
        audioPlayer.stop()
        self.delegate.endCallClicked()
    }
    
    
    @IBAction func acceptCall (_ sender: UIButton)
    {
        audioPlayer.stop()
        self.delegate.acceptCallClicked()
        self.dismiss(animated: false, completion: nil)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WaitingRoomView") as! WaitingRoomView
//        self.present(vc, animated: true, completion: nil)
    }
}
