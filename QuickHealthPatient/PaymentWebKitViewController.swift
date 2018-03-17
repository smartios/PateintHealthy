//
//  PaymentWebKitViewController.swift
//  QuickHealthPatient
//
//  Created by mac  on 18/01/18.
//  Copyright © 2018 SL161. All rights reserved.
//

import UIKit
import WebKit


class PaymentWebKitViewController: UIViewController,UIWebViewDelegate,WKNavigationDelegate {
    
    
    @IBOutlet var webView: WKWebView!
    var urlNew = ""
    var from = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // loading URL :
        let myBlog = urlNew
        let myURL = URL(string: myBlog)
        
        if myURL != nil
        {
            let request = URLRequest(url: myURL!)
            
            // init and load request in webview.
            webView = WKWebView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 64))
//            webView.frame =
            webView.navigationDelegate = self
            webView.load(request)
            self.view.addSubview(webView)
            
            supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "", labelText: "Loading..")
            webView.backgroundColor = UIColor.clear
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - web view delegate methods
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let mathString: String = ((webView.url)!.absoluteString)
        let numbers = mathString.components(separatedBy: ["/"])
        supportingfuction.hideProgressHudInView(view: self)
        
        if (numbers[numbers.count - 2]) != nil
        {
            print(numbers[numbers.count - 2])
            if  (numbers[numbers.count - 2]) == "payment-success"
            {
                supportingfuction.showMessageHudWithMessage(message: "Payment has been made.", delay: 2.0)
                
                if(from == "")
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "moveTotab4"), object: nil)
                    _ = self.navigationController?.popToRootViewController(animated: true)
                }
                else
                {
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "payment_success"), object: nil)
                    let vc: UIViewController = (self.navigationController?.viewControllers[((self.navigationController?.viewControllers)?.count)!-3])!
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }
    }
    
    @IBAction func backBtnTapper(sender: UIButton)
    {
        if(from == "")
        {
            _ = self.navigationController?.popViewController(animated: true)
        }
        else
        {
//             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "payment_success"), object: nil)
            let vc: UIViewController = (self.navigationController?.viewControllers[((self.navigationController?.viewControllers)?.count)!-3])!
            self.navigationController?.popToViewController(vc, animated: true)
        }
        
    }
}
