//
//  SelectPaymentMethodViewController.swift
//  QuickHealthPatient
//
//  Created by mac  on 17/01/18.
//  Copyright © 2018 SL161. All rights reserved.
//

import UIKit

protocol paymentCancelleDelegate {
    func cancelPayment()
}

class SelectPaymentMethodViewController: UIViewController {

    @IBOutlet weak var payViaMpesaBtnOutlet: UIButton!
    @IBOutlet weak var payViaPayPalBtnOutlet: UIButton!
    var id_appt_forPayment = Int()
    var price_forPayment = Int()
    var from = ""
    var delegate: paymentCancelleDelegate?
    
    @IBOutlet var textLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payViaPayPalBtnOutlet.setTitle("Pay Via Paypal", for: .normal)
        payViaMpesaBtnOutlet.setTitle("Pay Via M-Pesa", for: .normal)
        
        // setting border for both payment buttons
        payViaMpesaBtnOutlet.backgroundColor = .clear
        payViaMpesaBtnOutlet.layer.cornerRadius = 5
        payViaMpesaBtnOutlet.layer.borderWidth = 1
        payViaMpesaBtnOutlet.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0).cgColor
        
        payViaPayPalBtnOutlet.backgroundColor = .clear
        payViaPayPalBtnOutlet.layer.cornerRadius = 5
        payViaPayPalBtnOutlet.layer.borderWidth = 1
        payViaPayPalBtnOutlet.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0).cgColor

        
        let attributedString = NSMutableAttributedString(string: "You will be charged $\(price_forPayment) as a consultant fees for the slot of 20min with general physician. Please select you payment method.")
        
        attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor.black , range: attributedString.string.NSRangeFromRange(range: attributedString.string.range(of: "\(price_forPayment)")!))

        textLbl.attributedText = attributedString
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backBtnTapper(sender: UIButton)
    {
//         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "payment_success"), object: nil)
        _ = self.navigationController?.popViewController(animated: true)
        delegate?.cancelPayment()
    }

    @IBAction func payPaypalBtnTapped(_ sender: Any) {
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        let apiSniper = APISniper()
        
        let params = NSMutableDictionary()
        params.setObject(id_appt_forPayment, forKey: "id_appointment" as NSCopying)
        params.setValue(self.from, forKey: "type")
      //  params.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        apiSniper.getDataFromWebAPI(WebAPI.paypal_payment_request, params ,{(operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    if (dataFromServer.object(forKey: "data") as! NSDictionary).count > 0
                    {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentWebKitViewController") as! PaymentWebKitViewController
                        vc.from = self.from
                        vc.urlNew = (((dataFromServer ).object(forKey: "data") as! NSDictionary).object(forKey: "redirect_url") as! String)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else
                    {
                        supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                    }
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

extension String {
    func NSRangeFromRange(range : Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
        
    }
}
