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
    
  //  var webView: WKWebView!

    var webView: WKWebView!
    var urlNew = ""
    var from = ""
  
//    override func loadView() {
//        let webConfiguration = WKWebViewConfiguration()
//        webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        webView.uiDelegate = self as? WKUIDelegate
//        view = webView
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        webView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
//        view.addSubview(webView)
        
        // loading URL :
        let myBlog = urlNew
        let myURL = URL(string: myBlog)
        
        if myURL != nil
        {
        let request = URLRequest(url: myURL!)
        
        // init and load request in webview.
      
        webView = WKWebView(frame: self.view.frame)
         webView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 64)
        webView.navigationDelegate = self
        
        webView.load(request)
        
        self.view.addSubview(webView)
        webView.backgroundColor = UIColor.clear
        }
        
       // self.view.sendSubview(toBack: webView)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - web view delegate methods
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    private func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        let mathString: String = ((webView.url)!.absoluteString)
        let numbers = mathString.components(separatedBy: ["/"])
       
        if (numbers[numbers.count - 1]) != nil
        {
            print(numbers[numbers.count - 1])
            if  (numbers[numbers.count - 1]) == "payment-success"
            {
                 supportingfuction.showMessageHudWithMessage(message: "Payment has been made.", delay: 2.0)
                
                if(from == "")
                {
                    _ = self.navigationController?.popToRootViewController(animated: true)
                }
                else
                {
                    let vc: UIViewController = (self.navigationController?.viewControllers[((self.navigationController?.viewControllers)?.count)!-2])!
                    self.navigationController?.popToViewController(vc, animated: true)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "moveTotab4"), object: nil)
            }
        }
    }

    @IBAction func backBtnTapper(sender: UIButton)
    {
        if(from == "")
        {
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        else
        {
            let vc: UIViewController = (self.navigationController?.viewControllers[((self.navigationController?.viewControllers)?.count)!-2])!
            self.navigationController?.popToViewController(vc, animated: true)
        }
        //_ = self.navigationController?.popViewController(animated: true)
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
