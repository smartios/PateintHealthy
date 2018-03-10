//
//  VedioCallViewController.swift
//  QuickHealthDoctorApp
//
//  Created by SS042 on 19/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit
import OpenTok
import AVFoundation

class VideoCallViewController: UIViewController,PulsingCallDelegate {
    
    var session: OTSession! //epresents an OpenTok session and includes methods for interacting with the session.
    var publisher: OTPublisher? //uses the device's camera and microphone, to publish a stream OpenTok session.
    var subscriber: OTSubscriber? //uses the device's camera and microphone, to subscribe a stream OpenTok session.
    var subscriberView:UIView!
    var publisherView:UIView!
    var dataDic = NSMutableDictionary()
    
    
    //Local variables
    @IBOutlet var videoBtnView: VideoActionButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var callDuration: UILabel!
    @IBOutlet var patientID: UILabel!
    @IBOutlet var patientName: UILabel!
    @IBOutlet var cornerVedioView: UIView!
    
    var apointmentDict:NSDictionary!
    var chatMessages = ChatMessageGroup()
    //var prescriptionData = Prescription()
    var callDurationTimer:Timer!
    var timeRemaining = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoBtnView.isCallConnected = false
        self.videoBtnView.isHidden = true
        self.videoBtnView.delegate = self
        
        //Present pulsing screen from superview
        self.addCallingScreenToView()
        
        //Connect to the tocbox server
        //self.connectToAnOpenTokSession()
        
        //to set the values of doctor
        setValues()
        
        //Add tap gesture on self to get if user tapped on the screen
        self.addTapGestureOnScreen()
       NotificationCenter.default.addObserver(self, selector: #selector(endCallClicked), name: NSNotification.Name(rawValue: "call_canceled"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    
    func setValues()
    {
        patientName.text = "\((dataDic.value(forKey: "user_detail") as! NSDictionary).value(forKey: "first_name")!) \((dataDic.value(forKey: "user_detail") as! NSDictionary).value(forKey: "last_name")!)"
        patientID.text = "\((dataDic.value(forKey: "user_detail") as! NSDictionary).value(forKey: "unique_number")!)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTokboxApiSessionID(){
        //        if self.subscriber == nil{
        //            SocketIOManager.sharedInstance.sendVideoCallRequest(id_doctor: apointmentDict.object(forKey: "id_doctor") as! String, id_patient: apointmentDict.object(forKey: "id_patient") as! String, id_appointment: apointmentDict.object(forKey: "id_appointment") as! String, completionHandler: { (data) in
        //                print(data)
        //                //Connect to the tocbox server
        //                self.connectToAnOpenTokSession()
        //            })
        //        }
    }
    
    //Present pulsing screen in superview
    func addCallingScreenToView(){
        let tabStoryboard: UIStoryboard = UIStoryboard(name: "TabbarStoryboard", bundle: nil)
        let callingView = tabStoryboard.instantiateViewController(withIdentifier: "WaitingRoomViewController") as! WaitingRoomViewController
        callingView.delegate = self
        callingView.dataDict = self.dataDic
        self.present(callingView, animated: false, completion: nil)
    }
    
    //Dismiss pulsing screen from superview after call connect
    func removeCallingScreenFromView(){
        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
    }
    
    //remove chat screen if openedon tap
    func removeChildController(){
        var isChildPresent = false
        for vc in self.childViewControllers{
            if vc is WaitingChatRoomViewController{
                isChildPresent = true
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    vc.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 0)
                }) { _  in
                    vc.view.removeFromSuperview()
                    vc.removeFromParentViewController()
                }
            }
        }
        if isChildPresent{
            self.switchVideoStreamView(smallView: self.publisherView, largeView:self.subscriberView , isLargeNeeded: true)
        }
    }
    
    func addTapGestureOnScreen(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showHideButtonViewAddSelector))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func showHideButtonViewAddSelector(){
        self.removeChildController()
        //Set the buttonview isHidden property to false when user tapped on the screen
        self.videoBtnView.isHidden = false
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(self.setisHiddenForVideoBtnView), with: self, afterDelay: 5.0)
    }
    
    func setisHiddenForVideoBtnView(){
        self.videoBtnView.isHidden = true
    }
    
    func connectToAnOpenTokSession() {
        session = OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self)!
        var error: OTError?
        session.connect(withToken: kToken, error: &error)
        if error != nil {
            print(error!)
        }
    }
    
    func acceptCallClicked()
    {
        if(appDelegate.socketManager.isConnectedWithSocket == .connected)
        {
            NotificationCenter.default.removeObserver("call_accept_socket_not_connected")
            appDelegate.socketManager.call_accepted(dataDic: dataDic, accepted: true)
        }
        else
        {
            appDelegate.socketManager.establishConnection()
            NotificationCenter.default.addObserver(self, selector: #selector(acceptCallClicked), name: NSNotification.Name(rawValue: "call_accept_socket_not_connected"), object: nil)
        }
        
        self.errorLabel.isHidden = false
        self.errorLabel.text = "Please wait for doctor to join the call..."
        self.connectToAnOpenTokSession()
    }
    
    
    func endCallClicked() {
        var error: OTError?
        
        if self.publisher != nil{
            self.session.unpublish(self.publisher!, error: &error)
        }
        
        if self.session != nil{
            self.session.disconnect(&error)
        }
        
        appDelegate.socketManager.call_accepted(dataDic: dataDic, accepted: false)
        
        
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    /// Switch stream display destination in view
    ///
    /// - Parameters:
    ///   - smallView: the stream view need to display in corner of the screen in small view
    ///   - largeView: stream to be displayed in whole the screen
    ///   - isLargeNeeded: if need large screen the pass true other wiese false
    func switchVideoStreamView(smallView:UIView,largeView:UIView,isLargeNeeded:Bool){
        smallView.removeFromSuperview()
        largeView.removeFromSuperview()
        //set view on corner view
        smallView.frame = CGRect(x: 0, y: 0, width: self.cornerVedioView.frame.size.width, height: self.cornerVedioView.frame.size.height)
        self.cornerVedioView.addSubview(smallView)
        if isLargeNeeded{
            largeView.frame = UIScreen.main.bounds
            self.view.insertSubview(largeView, at: 1)
        }
    }
    
    //Start the duration timer after call connect
    func startCallDurationTimer(){
        if callDurationTimer == nil{
            callDurationTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self,      selector: #selector(timerRunning), userInfo: nil, repeats: true)
            timeRemaining = 20 * 60
        }
    }
    
    func timerRunning() {
        timeRemaining -= 1
        callDuration.text = self.timeString(time: TimeInterval(timeRemaining))
        if timeRemaining == 0{
            self.disconnectCallBtnClicked()
        }
    }
    
    /// Get time string with hours,minutes and seconds
    ///
    /// - Parameter time: Timeinterval in seconds
    /// - Returns: time string
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours,minutes,seconds)
    }
}

// MARK: - OTSessionDelegate callbacks
extension VideoCallViewController: OTSessionDelegate {
    func sessionDidConnect(_ session: OTSession) {
        print("The client connected to the OpenTok session.")
        
        let settings = OTPublisherSettings()
        settings.name = UIDevice.current.name
        guard let publish = OTPublisher(delegate: self, settings: settings) else {
            return
        }
        self.publisher = publish
        self.publisher?.publishVideo = true
        self.publisher?.publishAudio = true
        var error: OTError?
        session.publish(self.publisher!, error: &error)
        guard error == nil else {
            print(error!)
            return
        }
        
        guard let publisherV = self.publisher?.view else {
            return
        }
        self.publisherView = publisherV
        self.publisherView.frame = CGRect(x: 0, y: 0, width: self.cornerVedioView.frame.size.width, height: self.cornerVedioView.frame.size.height)
        self.cornerVedioView.addSubview(publisherView)
        
        self.errorLabel.isHidden = false
        
        self.errorLabel.text = "Please wait for doctor to join the call..."
        
        //Remove pulsing halo screen
        self.removeCallingScreenFromView()
        //Start the call timer after the patient connected to call
        //        self.startCallDurationTimer()
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        print("The client disconnected from the OpenTok session.")
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("The client failed to connect to the OpenTok session: \(error).")
    }
    
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("A stream was created in the session.")
        
        subscriber = OTSubscriber(stream: stream, delegate: self)
        guard let subscriber = subscriber else {
            return
        }
        
        var error: OTError?
        session.subscribe(subscriber, error: &error)
        guard error == nil else {
            print(error!)
            return
        }
        
        guard let subscriberV = subscriber.view else {
            return
        }
        self.subscriberView = subscriberV
        self.subscriberView.frame = UIScreen.main.bounds
        
        self.videoBtnView.isCallConnected =  true
        
        self.errorLabel.text = "Patient joined the call. Patient vedio feed will present shortly..."
    }
    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        
        if(self.subscriberView != nil)
        {
            self.subscriberView.removeFromSuperview()
        }
        
        self.errorLabel.isHidden = false
        self.errorLabel.text = "Opps, looks like the doctor is experiencing technical difficulties. \n Please wait for them to rejoin the call"
        print("A stream was destroyed in the session.")
        self.removeChildController()
    }
    
    
    
    func session(_ session: OTSession, receivedSignalType type: String?, from connection: OTConnection?, with string: String?) {
        
        var dict = NSMutableDictionary()
        dict = convertToDictionary(text: string!).mutableCopy() as! NSMutableDictionary
        
        if type! == "extendFreeCall"
        {
            let alertContoller = UIAlertController(title: "Extend Call", message: "Doctor extended call time by 5 minutes.", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertContoller.addAction(yesAction)
            self.present(alertContoller, animated: true, completion: nil)
        }
        else if type! == "extendPaidCall"{
            
            self.toShowExtendPaidCall(dict: dict)
        }
        else if type! == "endCall"{
            
            if let x = dict.object(forKey: "user_id") as? String
            {
                if x != (UserDefaults.standard.object(forKey: "user_id") as! String)
                {
                    let alertContoller = UIAlertController(title: "Alert!", message: "Call is diconnected from doctors end.", preferredStyle: .alert)
                    let yesAction = UIAlertAction(title: "OK", style: .default) { (alertAction) in
                        self.redirection_to_rating()
                    }
                    alertContoller.addAction(yesAction)
                    self.present(alertContoller, animated: true, completion: nil)
                }
            }
        }else if  type! == "streamStopped"{
            if dict.count > 0 {
                if dict.object(forKey: "user_id") != nil && dict.object(forKey: "user_id") as! String != (UserDefaults.standard.object(forKey: "user_id") as! String){
                    print("doctor Stop the stream")
                    self.switchVideoStreamView(smallView: self.publisherView, largeView: self.subscriberView, isLargeNeeded: false)
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "Doctor stopped sharing the video."
                }
            }
        }else if  type! == "streamReconnected"{
            if dict.count > 0 {
                if dict.object(forKey: "user_id") != nil &&  dict.object(forKey: "user_id") as! String != (UserDefaults.standard.object(forKey: "user_id") as! String){
                    print("doctor resume the stream")
                    self.errorLabel.isHidden = true
                    self.errorLabel.text = ""
                    self.switchVideoStreamView(smallView: self.publisherView, largeView: self.subscriberView, isLargeNeeded: true)
                    
                    
                }
            }
        }
        else if  type! == "ismuted_true"{
            if dict.count > 0 {
                if dict.object(forKey: "user_id") != nil && dict.object(forKey: "user_id") as! String != (UserDefaults.standard.object(forKey: "user_id") as! String){
                    print("Doctor muted the call")
                    
                    self.errorLabel.isHidden = false
                    self.errorLabel.textColor = UIColor.black
                    self.errorLabel.text = "Doctor muted this call."
                }
            }
        }else if  type! == "ismuted_false"{
            if dict.count > 0 {
                if dict.object(forKey: "user_id") != nil &&  dict.object(forKey: "user_id") as! String != (UserDefaults.standard.object(forKey: "user_id") as! String){
                    print("Doctor unmuted the call")
                    self.errorLabel.isHidden = true
                    self.errorLabel.textColor = UIColor.black
                    self.errorLabel.text = ""
                    
                    
                    
                }
            }
        }
        else if type! == "message"{
            
            if dict.count>0{
                self.chatMessages.messages.append(Message(json: dict))
                
                //Add chat controller on the view on message group
                if let vc = self.childViewControllers.last as? WaitingChatRoomViewController{
                    vc.messagesData = self.chatMessages
                }else{
                    self.removeChildController()
                    self.chatBtnClicked()
                }
            }
        }
    }
}

// MARK: - OTPublisherDelegate callbacks
extension VideoCallViewController: OTPublisherDelegate {
    func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
        print("The publisher failed: \(error)")
    }
}

// MARK: - OTSubscriberDelegate callbacks
extension VideoCallViewController: OTSubscriberDelegate {
    public func subscriberDidConnect(toStream subscriber: OTSubscriberKit) {
        print("The subscriber did connect to the stream.")
        self.errorLabel.isHidden = true
        
        //Insert the patient view in screen
        view.insertSubview(self.subscriberView, at: 1)
    }
    
    public func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        print("The subscriber failed to connect to the stream.")
    }
    
    func subscriberDidReconnect(toStream subscriber: OTSubscriberKit) {
        print("The subscriber reconnectconnect to the stream.")
    }
    
    func subscriberDidDisconnect(fromStream subscriber: OTSubscriberKit) {
        print("The subscriber disconnect to the stream.")
    }
}

// MARK: - VideoActionButtonDelegate callbacks
extension VideoCallViewController: VideoActionButtonDelegate {
    
    func muteUnmutebtnClicked(value:Bool) {
        self.publisher?.publishAudio = !value
        var error:OTError?
        let recieverDict = NSMutableDictionary()
        recieverDict.setValue(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id")
        var tempJson : NSString = ""
        do {
            let arrJson = try JSONSerialization.data(withJSONObject: recieverDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let string = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
            tempJson = string! as NSString
            print(tempJson)
        }catch let error as NSError{
            print(error.description)
        }
        
        if value == true{
            self.session.signal(withType: "ismuted_true", string: tempJson as String, connection: nil, retryAfterReconnect: true, error: &error)
            print("is_mute_true")
        }else{
            self.session.signal(withType: "ismuted_false", string: tempJson as String, connection: nil, retryAfterReconnect: true, error: &error)
            print("is_mute_false")
        }
        
    }
    
    func switchCameraBtnClicked() {
        if publisher?.cameraPosition == .back{
            publisher?.cameraPosition = AVCaptureDevicePosition.front // back camera
        }else{
            publisher?.cameraPosition = AVCaptureDevicePosition.back
        }
    }
    
    func stopSendingStreamBtnClicked(value:Bool) {
        
        var error : OTError?
        if value == true
        {
            let recieverDict = NSMutableDictionary()
            recieverDict.setValue(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id")
            var tempJson : NSString = ""
            
            do {
                let arrJson = try JSONSerialization.data(withJSONObject: recieverDict, options: JSONSerialization.WritingOptions.prettyPrinted)
                let string = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
                tempJson = string! as NSString
                print(tempJson)
                self.session.signal(withType: "streamStopped", string: tempJson as String, connection: nil, retryAfterReconnect: true, error: &error)
            }catch let error as NSError{
                print(error.description)
            }
            
            
            
            
            print("baba stream ni bheje")
        }else
        {
            
            
            let recieverDict = NSMutableDictionary()
            recieverDict.setValue(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id")
            var tempJson : NSString = ""
            do {
                let arrJson = try JSONSerialization.data(withJSONObject: recieverDict, options: JSONSerialization.WritingOptions.prettyPrinted)
                let string = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
                tempJson = string! as NSString
                print(tempJson)
                self.session.signal(withType: "streamReconnected", string: tempJson as String, connection: nil, retryAfterReconnect: true, error: &error)
            }catch let error as NSError{
                print(error.description)
            }
            
            // self.switchVideoStreamView(smallView: self.publisherView, largeView: self.subscriberView, isLargeNeeded: true)
        }
        
        
        publisher?.publishVideo = !value
    }
    
    func disconnectCallBtnClicked() {
        
        let alertContoller = UIAlertController(title: "Alert!", message: "Are you sure to disconnect call?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            
            var error: OTError?
            
            let recieverDict = NSMutableDictionary()
            recieverDict.setValue(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id")
            var tempJson : NSString = ""
            do {
                let arrJson = try JSONSerialization.data(withJSONObject: recieverDict, options: JSONSerialization.WritingOptions.prettyPrinted)
                let string = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
                tempJson = string! as NSString
                print(tempJson)
                
                self.session.signal(withType: "endCall", string: tempJson as String, connection: nil, retryAfterReconnect: true, error: &error)
                
                self.redirection_to_rating()
                
            }catch let error as NSError{
                print(error.description)
            }
            
            
           
            // self.session.signal(withType: "endCall", string: (UserDefaults.standard.object(forKey: "user_id") as! String), connection: nil, retryAfterReconnect: true, error: &error)
            
         //  self.perform(#selector(self.endCallClicked), with: self, afterDelay: 1.0)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertContoller.addAction(yesAction)
        alertContoller.addAction(cancelAction)
        self.present(alertContoller, animated: true, completion: nil)
        
    }
    
    func redirection_to_rating()
    {
        _ = self.navigationController?.popToRootViewController(animated: true)
        
        var error: OTError?
        if self.publisher != nil{
            self.session.unpublish(self.publisher!, error: &error)
        }
        if self.session != nil{
            self.session.disconnect(&error)
        }

        
        if(self.subscriberView != nil)
        {
            let vc = RatingViewController(nibName: "RatingViewController", bundle: nil)
            vc.from = "doctor"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    func chatBtnClicked() {
        let waitingChatRoomVC = WaitingChatRoomViewController()
        waitingChatRoomVC.view.tag = -786
        waitingChatRoomVC.messagesData = self.chatMessages
        waitingChatRoomVC.delegate = self
        self.view.addSubview(waitingChatRoomVC.view)
        
        waitingChatRoomVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 0)
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            
            waitingChatRoomVC.view.frame = CGRect(x: 0, y: 162, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 162)
            
        }) { _  in
            self.switchVideoStreamView(smallView: self.subscriberView, largeView: self.publisherView, isLargeNeeded: false)
        }
        self.addChildViewController(waitingChatRoomVC)
    }
    
    func prescriptionBtnClicked() {
        //        let prescriptionVC = PrescriptionFormViewController()
        //        prescriptionVC.prescriptionData = self.prescriptionData
        //        self.view.addSubview(prescriptionVC.view)
        //        prescriptionVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 0)
        //
        //        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
        //
        //            prescriptionVC.view.frame = CGRect(x: 0, y: 162, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 162)
        //
        //        }) { _  in
        //            self.switchVideoStreamView(smallView: self.subscriberView, largeView: self.publisherView, isLargeNeeded: false)
        //        }
        //        self.addChildViewController(prescriptionVC)
    }
    
    
    
    
}
// MARK: - WaitingChatRoomDelegate callbacks
extension VideoCallViewController: WaitingChatRoomDelegate,ExtendVideoDelegate {
    func didSelectOnExtendVideoAction(_ action: ExtendVideoAction, price: String) {
        
        let recieverDict = NSMutableDictionary()
        recieverDict.setValue(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id")
        var error : OTError?
        var tempJson : NSString = ""
        
        do {
            let arrJson = try JSONSerialization.data(withJSONObject: recieverDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let string = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
            tempJson = string! as NSString
            print(tempJson)
            
        }catch let error as NSError{
            print(error.description)
        }
        
        if action == .Thanks
        {
            self.session.signal(withType: "paidCallNotExtended", string: tempJson as String, connection: nil, retryAfterReconnect: true, error: &error)
        }
        else if action == .Paid
        {
            let story = UIStoryboard(name: "TabbarStoryboard", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "SelectPaymentMethodViewController") as! SelectPaymentMethodViewController
            vc.id_appt_forPayment = Int("\(UserDefaults.standard.object(forKey: "ongoing_id_appointment")!)")!
            vc.price_forPayment = Int(Double("\(price)")!)
            self.navigationController?.pushViewController(vc, animated: true)
            self.session.signal(withType: "paidCallExtended", string: tempJson as String, connection: nil, retryAfterReconnect: true, error: &error)
        }
    }
    
    func messageToSend(jsonString: String) {
        var error: OTError?
        session.signal(withType: "message", string: jsonString, connection: nil, retryAfterReconnect: true, error: &error)
    }
    
    func toShowExtendPaidCall(dict: NSMutableDictionary)
    {
        let extendVideoCallVC = ExtendVideoCallViewController()
        
        self.view.addSubview(extendVideoCallVC.view)
        extendVideoCallVC.amount = "\(dict.value(forKey: "paidCallCharge")!)"
        extendVideoCallVC.delegate = self
        
        extendVideoCallVC.view.frame = CGRect.zero
        
        extendVideoCallVC.view.center = self.view.center
        
        extendVideoCallVC.popCotainerView.isHidden = true
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .beginFromCurrentState, animations: {
            
            extendVideoCallVC.view.frame = self.view.bounds
            
        }) { _  in
            
            extendVideoCallVC.popCotainerView.isHidden = false
        }
        self.addChildViewController(extendVideoCallVC)
    }
    
    
}

