//
//  WaitingRoomView.swift
//  DAWProvider
//
//  Created by SS142 on 24/04/17.
//
//AllergyLablel.textColor

import UIKit
//import AudioToolbox
import AVFoundation
import OpenTok
import OpenTok

//var kApiKey = ""
//// Replace with your generated session ID
//var kSessionId = ""
//// Replace with your generated token
//var kToken = ""




let kWidgetHeight = 240
let kWidgetWidth = 320


class WaitingRoomView: UIViewController{
    
    
    lazy var session: OTSession = {
        return OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self)!
    }()
    lazy var publisher: OTPublisher = {
        let settings = OTPublisherSettings()
        settings.name = UIDevice.current.name
        return OTPublisher(delegate: self, settings: settings)!
    }()
    var callConnect = Bool()
    var subscriber: OTSubscriber?
    var subscribeToSelf = false
    
    @IBOutlet weak var headerViewHeightCons: NSLayoutConstraint!
    
    @IBOutlet var remoteUsername:UILabel!
    @IBOutlet weak var mainHeadingLbl: UILabel!
    @IBOutlet var AllergyLablel:UILabel!
    @IBOutlet var callStateLabel:UILabel!
    @IBOutlet var remoteVideoView:UIView!
    @IBOutlet var localVideoView:UIView!
    @IBOutlet weak var callId: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tapToReturnCallLabel: UILabel!
    @IBOutlet weak var tapToReturnCall: UIButton!
    @IBOutlet weak var tapToReturnCallnew: UIButton!
    
    @IBOutlet weak var pleaseWaitDocLbl: UILabel!
    @IBOutlet weak var secondButtonView: UIView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var docInfoView: UIView!
    @IBOutlet weak var bgBtn: UIButton?
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button5: UIButton!
    
    @IBOutlet weak var buttonMainView: UIView!
    @IBOutlet weak var callEndView: UIView!
    @IBOutlet weak var declineCall: UIView!
    @IBOutlet weak var extFiveMin: UIView!
    @IBOutlet weak var paymentSuccess: UIView!
    @IBOutlet weak var extFifteenMin: UIView!
    @IBOutlet weak var bookNextAppt: UIView!
    @IBOutlet weak var profileImgae: UIImageView!
    
    var userInterface = UIDevice.current.userInterfaceIdiom
    var chatvc : ChatOn!
    var isMute = false
    var isSpeakerPause = false
    var mode = ""
    var viewto = ""
    var typeToSend = ""
    var tap =  UITapGestureRecognizer()
    var gameTimer: Timer!
    //var messages = NSMutableArray()
    //var browse = UIViewController()
    var durationTimer = Timer()
    //    var call:SINCall!
    var callStatus = ""
    var indexCount = 0
    var dropBool = false
    var tappedIndex = -1
    // loacl timer code
    var isPaused = false
    var timer = Timer()
    // TIMER MGMT
    var counter = 0
    // popUPView
    // loader for caller name
   
    var chatBoxOpen = false
    var CallerDocDict = NSMutableDictionary()
    var incommingCallTimer = Timer()
    var assignmissed = false
    var callDelayTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let x = UserDefaults.standard.object(forKey: "serviceType") as? String
        {
            //code for Lactation Consulatant
            if x == "lactationConsulatant"
            {
                mainHeadingLbl.text = "LACTATION CONSULTANT VIDEO CONNECT"
            }else if x == "medicalService"
            {
                mainHeadingLbl.text = "MEDICAL SERVICE VIDEO CONNECT"
            }else
            {
                // do nothing
            }
        }


        
        button2.isHidden = true
        
        self.startCallDurationTimer(with: #selector(self.onDurationTimer))
        docInfoView.isHidden = false
        
        profileImgae.layer.cornerRadius = (profileImgae.frame.height)/2
        profileImgae.clipsToBounds = true
        
     
        counter = 0
        headerViewHeightCons.constant = 0
        headerLabel.text = ""
        tapToReturnCallLabel.isHidden = true
        tapToReturnCallnew.isHidden = true
        tapToReturnCall.isHidden = true
        button1.isHidden = true
        button2.isHidden = true
        button3.isHidden = true
        button4.isHidden = true
        button5.isHidden = true
        callEndView.isHidden = true
        viewto = "waitingView"
        button3.setBackgroundImage(UIImage(named:"unmute"), for: .normal)
        
        start_CAll()
    }
    
    
    func start_CAll()
    {

        remoteUsername.text = "VARUN PANDEY"
        AllergyLablel.text = "AllergyLablel"
        callId.text = "ID:123456780"
        
    kApiKey = "46062412"
    kSessionId = "1_MX40NjA2MjQxMn5-MTUxOTAyNDIyMDEzOX4wbCt3TTRpUEhVTzQydlBqcTgwYW4zeUp-fg"
    kToken = "T1==cGFydG5lcl9pZD00NjA2MjQxMiZzZGtfdmVyc2lvbj1kZWJ1Z2dlciZzaWc9ZGFjNDY2ODQ5ZmRiNDg2Y2E5MTU3NWQyZTNhNGQ3OTdlM2M4MzUwNzpzZXNzaW9uX2lkPTFfTVg0ME5qQTJNalF4TW41LU1UVXhPVEF5TkRJeU1ERXpPWDR3YkN0M1RUUnBVRWhWVHpReWRsQnFjVGd3WVc0emVVcC1mZyZjcmVhdGVfdGltZT0xNTE5MDI0MjIwJnJvbGU9bW9kZXJhdG9yJm5vbmNlPTE1MTkwMjQyMjAuMTQyMTE2MjA4NTgwMDQmZXhwaXJlX3RpbWU9MTUyMTYxNjIyMA=="
    
    
    
    if kApiKey != nil && kApiKey != "" && kSessionId != nil && kSessionId != "" && kSessionId != nil && kSessionId != ""
    {
    self.session = {
    return OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self)!
    }()
    self.doConnect()
        
    }
    else
    {
//    appDelegate.showMessageHudWithMessage(message: "API KEY, SESSION ID AND TOKEN connot be null.", delay: 2.0)
    }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.isIdleTimerDisabled = true

        
        if appDelegate.gameTimer != nil
        {
            appDelegate.gameTimer.invalidate()
        }
        
        if appDelegate.timer != nil
        {
            appDelegate.timer.invalidate()
        }
        
        AllergyLablel.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
         UIApplication.shared.isIdleTimerDisabled = false
        supportingfuction.hideProgressHudInView(view: self)
    }
    
    
    // to hide the doc view and show in 10 sec duration
    func hideDocInfoView()
    {
        if chatBoxOpen == false
        {
            docInfoView.isHidden = false
            buttonMainView.isHidden = false
            gameTimer = Timer.scheduledTimer(timeInterval: 03.00, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: false)
        }
    }
    
    func runTimedCode()
    {
        if chatBoxOpen == false
        {
            docInfoView.isHidden = true
            buttonMainView.isHidden = true
        }
    }
    // for calling not used is patient end
    @IBAction func callButtonClicked(_ sender: UIButton) {
        callEndView.isHidden = false
        declineCall.isHidden = false
        extFiveMin.isHidden = true
        paymentSuccess.isHidden = true
        extFifteenMin.isHidden = true
        bookNextAppt.isHidden = true
        self.view.bringSubview(toFront: callEndView)
    }
    
   
    
    
    @IBAction func tapToReturnBtnClicked(_ sender: UIButton) {
        
        if callStatus == "connected"
        {
            publisher.view?.removeFromSuperview()
            subscriber?.view?.removeFromSuperview()
            publisher.view?.frame = CGRect(x: 0, y: 0, width: self.localVideoView.frame.size.width, height: self.localVideoView.frame.size.height)
            localVideoView.addSubview(publisher.view!)
            //big view
            if let subsView = subscriber?.view {
                subsView.frame = remoteVideoView.frame
                remoteVideoView.addSubview(subsView)
                remoteVideoView.clipsToBounds = true
            }
            
            callId.textColor = UIColor.white
            callStateLabel.textColor = UIColor.white
            remoteUsername.textColor = UIColor.white
        }
        chatBoxOpen = false
        
        if callStatus == "connected"
        {
            bgBtn?.isHidden = false
            hideDocInfoView()
        }
        
        let vc = self.childViewControllers.last
        
        vc?.view.removeFromSuperview()
        vc?.removeFromParentViewController()
        
        chatvc.view.removeFromSuperview()
        chatvc.removeFromParentViewController()
        
        headerLabel.text = "CURRENT PATIENT"
        tapToReturnCallLabel.isHidden = true
        tapToReturnCall.isHidden = true
        if callStatus == "connected"
        {
            callId.textColor = UIColor.white
            callStateLabel.textColor = UIColor.white
            remoteUsername.textColor = UIColor.white
        }
        
        tapToReturnCallLabel.isHidden = true
        docInfoView.isHidden = true
        buttonMainView.isHidden = true
        tapToReturnCall.isHidden = true
        tapToReturnCallnew.isHidden = true
    }
    
    @IBAction func chatBtnClecked(_ sender: UIButton) {
        
        
        callId.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
        callStateLabel.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
        remoteUsername.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
        
        if callStatus == "connected"
        {
            publisher.view?.removeFromSuperview()
            subscriber?.view?.removeFromSuperview()
            if let subsView = subscriber?.view {
                subsView.frame =  CGRect(x: 0, y: 0, width: self.localVideoView.frame.size.width, height: self.localVideoView.frame.size.height)
                localVideoView.addSubview(subsView)
                localVideoView.clipsToBounds = true
               
            }
        }
        
        
        chatBoxOpen = true
        gameTimer.invalidate()
        let vc1 = self.childViewControllers.last
        vc1?.view.removeFromSuperview()
        vc1?.removeFromParentViewController()
        headerLabel.text = "CHAT"
        tapToReturnCallLabel.isHidden = false
        tapToReturnCall.isHidden = false
        chatvc = self.storyboard?.instantiateViewController(withIdentifier: "ChatOn") as! ChatOn
        
        chatvc.view.frame = CGRect(x: 0, y: 212, width: self.view.frame.width, height: self.view.frame.height-(190))
        chatvc.session = self.session
        self.addChildViewController(chatvc)
        self.view.addSubview(chatvc.view)
        chatvc.didMove(toParentViewController: self)
        tapToReturnCallLabel.isHidden = false
        docInfoView.isHidden = false
        tapToReturnCall.isHidden = false
        tapToReturnCallnew.isHidden = false
        // self.view.bringSubview(toFront: detailButton)
    }
    
    
    func callEstablish()
    {
        tap =  UITapGestureRecognizer(target: self, action: #selector(WaitingRoomView.hideDocInfoView))
        bgBtn?.addGestureRecognizer(tap)
        callStatus = "connected"
        AllergyLablel.textColor = UIColor.white
        button2.setBackgroundImage(UIImage(named:"disconnectCall"), for: .normal)
        button1.isHidden = false
        button2.isHidden = false
        button3.isHidden = false
        button4.isHidden = false
        button5.isHidden = false
        docInfoView.isHidden = true
        buttonMainView.isHidden = true
        // buttonMainView.isHidden = false
        
    }
    // MARK:- disconnectCall
    @IBAction func disconnectCallBtnClicked(_ sender: UIButton) {
        callEndView.isHidden = false
        declineCall.isHidden = false
        extFiveMin.isHidden = true
        paymentSuccess.isHidden = true
        extFifteenMin.isHidden = true
        bookNextAppt.isHidden = true
        buttonMainView.isHidden = false
        self.view.bringSubview(toFront: callEndView)
        if sender.tag == 11
        {
            assignmissed = true
        }
        
    }
    
    
    func hideMenu()
    {
        tappedIndex = -1
    }
    
    

    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        callEndView.isHidden = true
    }
    
    @IBAction func confirmBtnClicked(_ sender: UIButton) {
        durationTimer.invalidate()
        durationTimer = Timer()
        button1.isHidden = true
        button2.isHidden = true
        button3.isHidden = true
        button4.isHidden = true
        button5.isHidden = true
        callEndView.isHidden = true
        callStatus = ""
        
        if  assignmissed == true
        {
            assignmissed = false
           // missedApptStatusUpdate()
        }
        
        callDisconnect()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setCallStatusText(text:String)
    {
        if text == "calling..." || text == "ringing"
        {
            self.callStateLabel.text = text;
        }else
        {
            self.callStateLabel.text = "00:" + text;
        }
    }
    
    func showButtons(buttons:EButtonsBar)
    {
        if (buttons == EButtonsBar.kButtonsAnswerDecline) {
            
        } else if (buttons == EButtonsBar.kButtonsHangup) {
            
        }
    }
    
    
    //MARK:- Change camera fucntions
    
    @IBAction func onSwitchCameraTapped(sender:UIButton)
    {
        if publisher.cameraPosition == .back
        {
            publisher.cameraPosition = AVCaptureDevicePosition.front // back camera
        }
        else
        {
            publisher.cameraPosition = AVCaptureDevicePosition.back
        }
    }
    
    
    
    @IBAction func muteTapped(sender:UIButton)
    {
        if isMute == false
        {
            mute()
            isMute = true
        }else
        {
            isMute = false
            unMute()
            
        }
    }
    
    func unMute() {
        
        publisher.publishAudio = true
        publisher.publishVideo = true
        button3.setBackgroundImage(UIImage(named:"unmute"), for: .normal)
    }
    
    func mute() {
        publisher.audioLevelDelegate = nil
        publisher.publishAudio = false
        button3.setBackgroundImage(UIImage(named:"mute"), for: .normal)
    }
    
    @IBAction func playResume(sender:UIButton)
    {
        if publisher.publishVideo == true
        {
            sender.isSelected = true
            publisher.publishVideo = false
            //button5.setBackgroundImage(UIImage(named:"playVideo"), for: .normal)
        }
        else
        {
            sender.isSelected = false
            publisher.publishVideo = true
            // button5.setBackgroundImage(UIImage(named:"pause"), for: .normal)
        }
        
    }
    
    //MARK:- Duration
    func onDurationTimer(unused:Timer)
    {
        counter = ((counter+1))
        let value = Int(counter/2)
        self.setDuration((value))
        print(value)
        
        if value > 180
        {
            stopCallDurationTimer()
            secondButtonView.isHidden = false
            button1.isHidden = true
            button2.isHidden = true
            button3.isHidden = true
            button4.isHidden = true
            button5.isHidden = true
        }else
        {
            secondButtonView.isHidden = true
            
        }
    }
    
    // nothanx and ok button action of popups
    @IBAction func noThanksBtnClicked(_ sender: UIButton) {
        callEndView.isHidden = true
        self.startCallDurationTimer(with: #selector(self.onDurationTimer))
        //  print("i m callign 2")
    }
    
    func setDuration(_ seconds: Int) {
        self.setCallStatusText(text: String(format: "%02d:%02d", Int(seconds / 60), Int(seconds % 60)))
        //  print("i m callign 2")
        
        if(!appDelegate.hasConnectivity())
        {
            supportingfuction.showMessageHudWithMessage(message: NoInternetConnection as NSString, delay: 2.0)
            //            self.call.hangup()
            //            self.audioController().stopPlayingSoundFile()
            //            self.videoController().remoteView().removeFromSuperview()
            //            self.audioController().disableSpeaker()
            durationTimer.invalidate()
            durationTimer = Timer()
            button1.isHidden = true
            button2.isHidden = true
            button3.isHidden = true
            button4.isHidden = true
            button5.isHidden = true
            callEndView.isHidden = true
            callStatus = ""
            
            self.dismiss(animated: true, completion: nil)
             supportingfuction.hideProgressHudInView(view: self)
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        else
        {
        }
    }
    
    func internal_updateDuration(_ timer: Timer) {
        let selector: Selector? = NSSelectorFromString(timer.userInfo as! String)
        if responds(to: selector) {
            perform(selector, with: timer)
        }
    }
    
    func startCallDurationTimer(with sel: Selector) {
        let selectorAsString: String = NSStringFromSelector(sel)
        durationTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.internal_updateDuration), userInfo: selectorAsString, repeats: true)
    }
    
    func stopCallDurationTimer() {
        durationTimer.invalidate()
        durationTimer = Timer()
    }
    
    
    func callDidEnd() {
        supportingfuction.hideProgressHudInView(view: self)
        
        appDelegate.chatMessages.removeAllObjects()
        //        self.audioController().stopPlayingSoundFile()
        //        self.videoController().remoteView().removeFromSuperview()
        localVideoView.isHidden = true
        //        self.audioController().disableSpeaker()
        callStateLabel.text = "00:00:00"
        durationTimer.invalidate()
        durationTimer = Timer()
        buttonMainView.isHidden = false
        
        callStatus = ""
        callId.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
        callStateLabel.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
        remoteUsername.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
        mainHeadingLbl.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
        AllergyLablel.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
        counter = 0
        let vc = self.childViewControllers.last
        if vc?.restorationIdentifier == "ChatOn"
        {
            vc?.view.removeFromSuperview()
            vc?.removeFromParentViewController()
        }
        self.dismiss(animated: true, completion: nil)
       supportingfuction.hideProgressHudInView(view: self)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tyScreenNoti"), object: nil)
    }
    
    
    
    //MARK:- Sounds
    func pathForSound(soundName:String) -> String
    {
        return (Bundle.main.resourcePath?.stringByAppendingPathComponent(pathComponent: soundName))!
    }
    
    //MARK:- Notification Action function immideate/next appt options
    
    // action and function for next immediate slot selection
   
    
   
    
    // action and function for next bookNextSlot  selection
   
    
    //MARK:- getUserData to achive into of doctor...
    
    
    fileprivate func doConnect() {
        var error: OTError?
        defer {
            processError(error)
        }
        self.button2.isHidden = true
        session.connect(withToken: kToken, error: &error)
        button2.setBackgroundImage(UIImage(named:"disconnectCall"), for: .normal)
    }
    
    func callDisconnect()
    {
        
        var error: OTError?
        session.unpublish(publisher, error: &error)
        session.disconnect(&error)
        button2.setBackgroundImage(UIImage(named:"connectCall"), for: .normal)
        callConnect = false
        callDidEnd()
    }
    

    
    
    fileprivate func doPublish() {
        var error: OTError?
        defer {
            processError(error)
        }
        session.publish(publisher, error: &error)
        callEstablish()
        publisher.view?.frame = CGRect(x: 0, y: 0, width: self.localVideoView.frame.size.width, height: self.localVideoView.frame.size.height)
        localVideoView.addSubview(publisher.view!)
    }
    
    /**
     * Instantiates a subscriber for the given stream and asynchronously begins the
     * process to begin receiving A/V content for this stream. Unlike doPublish,
     * this method does not add the subscriber to the view hierarchy. Instead, we
     * add the subscriber only after it has connected and begins receiving data.
     */
    fileprivate func doSubscribe(_ stream: OTStream) {
        durationTimer.invalidate()
        pleaseWaitDocLbl.isHidden = true
        print("sumbdy is connected on call")
        var error: OTError?
        defer {
            processError(error)
        }
        subscriber = OTSubscriber(stream: stream, delegate: self)
        session.subscribe(subscriber!, error: &error)
    }
    
    fileprivate func cleanupSubscriber() {
        subscriber?.view?.removeFromSuperview()
        subscriber = nil
        
    }
    
    fileprivate func processError(_ error: OTError?) {
        if let err = error {
            DispatchQueue.main.async {
                let controller = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    

    
   
}

extension String {
    func stringByAppendingPathComponent(pathComponent: String) -> String {
        return (self as NSString).appendingPathComponent(pathComponent)
    }
}

// MARK: - OTSession delegate callbacks
extension WaitingRoomView: OTSessionDelegate {
    func sessionDidConnect(_ session: OTSession) {
        print("Session connected")
        doPublish()
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        print("Session disconnected by doctor")
        
        self.dismiss(animated: true, completion: nil)
        supportingfuction.hideProgressHudInView(view: self)
        // _ = navigationController?.popToRootViewController(animated: false)
        
        callDisconnect()
    }
    
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("Session streamCreated: \(stream.streamId)")
        if subscriber == nil && !subscribeToSelf {
            doSubscribe(stream)
        }
    }
    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        
        //when doc disconnect call
        pleaseWaitDocLbl.isHidden = false
        pleaseWaitDocLbl.text = "Opps, looks like the doctor is experiencing technical difficulties. \n Please wait for them to rejoin the call"
        print("Session streamDestroyed: \(stream.streamId)")
        if let subStream = subscriber?.stream, subStream.streamId == stream.streamId {
            cleanupSubscriber()
        }
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("session Failed to connect: \(error.localizedDescription)")
    }
    func session(_ session: OTSession, receivedSignalType type: String?, from connection: OTConnection?, with string: String?) {
        print("Received signal \(string)")
        
        if type == "endCall"
        {
            durationTimer.invalidate()
            durationTimer = Timer()
            button1.isHidden = true
            button2.isHidden = true
            button3.isHidden = true
            button4.isHidden = true
            button5.isHidden = true
            callEndView.isHidden = true
            callStatus = ""
            
            if  assignmissed == true
            {
                assignmissed = false
              //  missedApptStatusUpdate()
            }
            
             supportingfuction.hideProgressHudInView(view: self)
            callDisconnect()
            
        }else
        {
            let vc1 = self.childViewControllers.last
            vc1?.view.removeFromSuperview()
            vc1?.removeFromParentViewController()
            headerLabel.text = "CHAT"
            tapToReturnCallLabel.isHidden = false
            tapToReturnCall.isHidden = false
            chatvc = self.storyboard?.instantiateViewController(withIdentifier: "ChatOn") as! ChatOn
            
            chatvc.view.frame = CGRect(x: 0, y: 212, width: self.view.frame.width, height: self.view.frame.height-(190))
            chatvc.session = self.session
            self.addChildViewController(chatvc)
            self.view.addSubview(chatvc.view)
            chatvc.didMove(toParentViewController: self)
            
            var dict = NSMutableDictionary()
            dict = convertToDictionary(text: string!).mutableCopy() as! NSMutableDictionary
            if dict.count>0
            {
                let recieverDict = NSMutableDictionary()
                recieverDict.setValue(dict.object(forKey: "data") as! String, forKey: "message")
                recieverDict.setValue(dict.object(forKey: "senderName") as! String, forKey: "senderName")
                if dict.object(forKey: "user_id") != nil
                {
                  recieverDict.setValue(dict.object(forKey: "user_id") as! String, forKey: "user_id")
                }else
                {
                      recieverDict.setValue("", forKey: "user_id")
                }
                appDelegate.chatMessages.add(recieverDict)
                print(appDelegate.chatMessages)
            }
            chatvc.tblChat.reloadData()
            
            chatvc.scrollToBottom()
            chatBoxOpen = true
            tapToReturnCallLabel.isHidden = false
            docInfoView.isHidden = false
            tapToReturnCall.isHidden = false
            tapToReturnCallnew.isHidden = false
            
            callId.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
            callStateLabel.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
            remoteUsername.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
            
            if callStatus == "connected"
            {
                publisher.view?.removeFromSuperview()
                subscriber?.view?.removeFromSuperview()
                if let subsView = subscriber?.view {
                    subsView.frame =  CGRect(x: 0, y: 0, width: self.localVideoView.frame.size.width, height: self.localVideoView.frame.size.height)
                    localVideoView.addSubview(subsView)
                    localVideoView.clipsToBounds = true
                    // self.view.bringSubview(toFront: localVideoView)
                    //                 docInfoView.backgroundColor = UIColor.lightGray
                }
            }
            
            
        }
        
        
        
    }
    
    
}

func convertToDictionary(text: String) -> NSDictionary {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as!NSDictionary
        } catch {
            print(error.localizedDescription)
        }
    }
    return NSDictionary()
}

// MARK: - OTPublisher delegate callbacks
extension WaitingRoomView: OTPublisherDelegate {
    func publisher(_ publisher: OTPublisherKit, streamCreated stream: OTStream) {
        if subscriber == nil && subscribeToSelf{
            doSubscribe(stream)
        }
    }
    
    func publisher(_ publisher: OTPublisherKit, streamDestroyed stream: OTStream) {
        if let subStream = subscriber?.stream, subStream.streamId == stream.streamId {
            cleanupSubscriber()
        }
    }
    
    func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
        print("Publisher failed: \(error.localizedDescription)")
    }
}

// MARK: - OTSubscriber delegate callbacks
extension WaitingRoomView: OTSubscriberDelegate {
    func subscriberDidConnect(toStream subscriberKit: OTSubscriberKit) {
        if let subsView = subscriber?.view {
            subsView.frame = remoteVideoView.frame
            remoteVideoView.addSubview(subsView)
            remoteVideoView.clipsToBounds = true
        }
    }
    
    func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        print("Subscriber failed: \(error.localizedDescription)")
    }
}

