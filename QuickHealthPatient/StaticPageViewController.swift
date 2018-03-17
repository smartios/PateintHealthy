//
//  StaticPageViewController.swift
//  DAWPatient
//
//  Created by SS043 on 09/02/17.
//  Copyright © 2017 SS043. All rights reserved.
//

import UIKit


class StaticPageViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var pageTitle = UILabel()
    @IBOutlet weak var webView = UIWebView()
    
    var commingFromScreen = ""
    
    // var baseURL = ""
    //var urlAddress = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView?.scalesPageToFit = true
        
        let reach: Reachability
        do{
            reach = try Reachability.forInternetConnection()
            if reach.isReachable(){
                
                
                if appDelegate.staticpage ==  "about-us"
                {
                    pageTitle?.text = "ABOUT QUICKHEALTH"
                }else if appDelegate.staticpage ==  "terms-and-conditions"
                {
                    pageTitle?.text = "TERMS & CONDITIONS"
                    
                }else if appDelegate.staticpage ==  "privacy-policy"
                {
                    pageTitle?.text = "PRIVACY POLICY"
                }else
                {
                    pageTitle?.text = "TERMS & CONDITIONS"
                }
                
                getUserData()
            }else
            {
                supportingfuction.showMessageHudWithMessage(message: "Please check your internet connection.", delay: 2.0)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backbtnTapped(sender: UIButton){
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disagreebtnClicked"), object: nil)
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func agreeTapped(sender: UIButton){
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "agreebtnClicked"), object: nil)
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    func getUserData()
    {
        var url: URL!
        
        if commingFromScreen == "signupView"
        {
            url = URL (string: ("\(WebAPI.static_pages_url)terms-and-conditions" ))
        }
        else
        {
            url = URL (string: ("\(WebAPI.static_pages_url)\(appDelegate.staticpage)" ))
        }
        
        let requestObj = URLRequest(url: url!)
        self.webView?.loadRequest(requestObj)
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        supportingfuction.hideProgressHudInView(view: self)
    }
}
