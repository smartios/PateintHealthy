//
//  PrescribedFormViewController.swift
//  QuickHealthDoctorApp
//
//  Created by SL036 on 23/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit

class PrescribedFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var prescribedTableView: UITableView!{
        didSet{
            prescribedTableView.estimatedRowHeight = 80
            prescribedTableView.rowHeight = UITableViewAutomaticDimension
            
            prescribedTableView.estimatedSectionHeaderHeight = 50
            prescribedTableView.sectionHeaderHeight = UITableViewAutomaticDimension
            prescribedTableView.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "headerCell")
            prescribedTableView.register(UINib(nibName: "PrescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "prescriptionDescriptionCell")
            prescribedTableView.register(UINib(nibName: "PrescribedDrugTableViewCell", bundle: nil), forCellReuseIdentifier: "prescribedCell")
            prescribedTableView.register(UINib(nibName: "TotalAmountTableViewCell", bundle: nil), forCellReuseIdentifier: "totalAmountCell")
            prescribedTableView.register(UINib(nibName: "PrescribedLabTestTableViewCell", bundle: nil), forCellReuseIdentifier: "labTestCell")
            prescribedTableView.register(UINib(nibName: "QuestionsTableViewCell", bundle: nil), forCellReuseIdentifier: "questionCell")
            prescribedTableView.register(UINib(nibName: "PaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "buttonCell")
        }
    }
    
    var dataDic = NSMutableDictionary()
    var is_drug_yes:Bool = false
    var is_lab_test:Bool = false
    var is_visible = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        history_detail()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Back Action
    @IBAction func onClickedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- Proceed to Payment
    @IBAction func onClickedMakePayment(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK:- UITableView DataSource/Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        if section == 0
        {
            return 1
        }
        else if section == 1 && dataDic.value(forKey: "prescription") != nil
        {
            return 1
        }
        else if section == 2 && (dataDic.value(forKey: "drug") != nil && (dataDic.value(forKey: "drug") as! NSArray).count > 0)
        {
            if(is_visible)
            {
                 return (dataDic.value(forKey: "drug") as! NSArray).count + 1
            }
            else
            {
                 return (dataDic.value(forKey: "drug") as! NSArray).count
            }
           
        }
        else if section == 3 && (dataDic.value(forKey: "lab_test") != nil && (dataDic.value(forKey: "lab_test") as! NSArray).count > 0)
        {
            if(is_visible)
            {
                return (dataDic.value(forKey: "lab_test") as! NSArray).count + 1
            }
            else
            {
                return (dataDic.value(forKey: "lab_test") as! NSArray).count
            }
        }
        else if section == 4 && ((dataDic.value(forKey: "lab_test") != nil && (dataDic.value(forKey: "lab_test") as! NSArray).count > 0) || (dataDic.value(forKey: "drug") != nil && (dataDic.value(forKey: "drug") as! NSArray).count > 0))
        {
            return 1
        }
        else if section == 5 && (is_lab_test || is_drug_yes) && is_visible
        {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableHeader = TableViewHeader()
        let tableHeaderContent = tableHeader.viewWithTag(191) as! UILabel
        tableHeaderContent.text = ""
        
        
        if section == 1 && dataDic.value(forKey: "prescription") != nil
        {
            tableHeaderContent.text = "PRESCRIPTION"
        }
        else if section == 2 && (dataDic.value(forKey: "drug") != nil && (dataDic.value(forKey: "drug") as! NSArray).count > 0)
        {
            tableHeaderContent.text = "PRESCRIBED DRUGS"
        }
        else if section == 3 && (dataDic.value(forKey: "lab_test") != nil && (dataDic.value(forKey: "lab_test") as! NSArray).count > 0)
        {
            tableHeaderContent.text = "LAB TEST"
        }
       
        
        return tableHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        if section == 1 || (section == 2 && (dataDic.value(forKey: "drug") != nil && (dataDic.value(forKey: "drug") as! NSArray).count > 0)) || (section == 3 &&  (dataDic.value(forKey: "lab_test") != nil && (dataDic.value(forKey: "lab_test") as! NSArray).count > 0))
        {
            return UITableViewAutomaticDimension
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
            return self.cellForHeaderContent(cell, indexPath: indexPath)
        }
        else if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "prescriptionDescriptionCell") as! PrescriptionTableViewCell
            return self.cellForPrescriptionDescription(cell, indexPath: indexPath)
        }
        else if indexPath.section == 2
        {
            if (dataDic.value(forKey: "drug") != nil && indexPath.row == (dataDic.value(forKey: "drug") as! NSArray).count) && is_visible
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuestionsTableViewCell
                return self.cellForQuestionAsking(cell, indexPath: indexPath)
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "prescribedCell") as! PrescribedDrugTableViewCell
                return self.cellForPrescribedDrugs(cell, indexPath: indexPath)
            }
        }
        else if indexPath.section == 3
        {
            if (dataDic.value(forKey: "lab_test") != nil && indexPath.row == (dataDic.value(forKey: "lab_test") as! NSArray).count) && is_visible
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuestionsTableViewCell
                return self.cellForQuestionAsking(cell, indexPath: indexPath)
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "labTestCell") as! PrescribedLabTestTableViewCell
                return self.cellLabTestName(cell, indexPath: indexPath)
            }
        }
        else if indexPath.section == 5 && (is_lab_test || is_drug_yes)  && is_visible
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell") as! PaymentTableViewCell
            return self.cellForPaymentButton(cell, indexPath: indexPath)
        }
        else //if indexPath.section == 4
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "totalAmountCell") as! TotalAmountTableViewCell
            return self.cellForTotalAmount(cell, indexPath: indexPath)
        }
    }
    
    // MARK:- Header Cell
    func cellForHeaderContent(_ cell: HeaderTableViewCell, indexPath: IndexPath) -> UITableViewCell
    {
        let profile_img = cell.viewWithTag(102) as! UIImageView
        let nameLabel = cell.viewWithTag(104) as! UILabel
        let iDLabel = cell.viewWithTag(105) as! UILabel
        let detailBtn = cell.viewWithTag(106) as! UIButton
        let dateLabel = cell.viewWithTag(108) as! UILabel
        let timeLabel = cell.viewWithTag(110) as! UILabel
        let specializationLabel = cell.viewWithTag(111) as! UILabel
        let ratingView = cell.viewWithTag(112) as! FloatRatingView
        ratingView.editable = false
        
        if(dataDic.value(forKey: "appointment_detail") != nil && (dataDic.value(forKey: "appointment_detail") as! NSDictionary).value(forKey: "doctor_detail") != nil)
        {
            let profileDict = (dataDic.value(forKey: "appointment_detail") as! NSDictionary).value(forKey: "doctor_detail") as! NSDictionary
            detailBtn.addTarget(self, action: #selector(detailBtnTapped(_:)), for: .touchUpInside)
            
            if let x = (profileDict.value(forKey: "user_image") as? String)
            {
                profile_img.setImageWith(URL(string: "\(x)")!, placeholderImage: #imageLiteral(resourceName: "profile"))
                profile_img.contentMode = .scaleAspectFit
                profile_img.clipsToBounds = true
            }
            else
            {
                profile_img.image = #imageLiteral(resourceName: "default_profile_image")
            }
            
            if let x = (profileDict.value(forKey: "first_name") as? String), let y = (profileDict.value(forKey: "last_name") as? String)
            {
                nameLabel.text = "\(x) \(y)"
                headingLabel.text = "\(x) \(y)"
            }
            else
            {
                nameLabel.text = "NA"
            }
            
            
            if let x = ((dataDic.value(forKey: "call") as! NSDictionary).value(forKey: "call_start") as? String)
            {
                dateLabel.text = CommonValidations.getDateStringFromDateString(date: x, fromDateString: "yyyy-MM-dd HH:mm:ss", toDateString: "dd MMM, yyyy")
                
                timeLabel.text = CommonValidations.getDateStringFromDateString(date: x, fromDateString: "yyyy-MM-dd HH:mm:ss", toDateString: "hh:mm a")
            }
            else
            {
                dateLabel.text = "NA"
                 timeLabel.text = "NA"
            }
            
            if let x = (profileDict.value(forKey: "unique_number") as? String)
            {
                iDLabel.text = x
            }
            else
            {
                iDLabel.text = "NA"
            }
            
            if let x = (profileDict.value(forKey: "service_title") as? String)
            {
                specializationLabel.text = x
            }
            else
            {
                specializationLabel.text = "NA"
            }
            
            if(profileDict.value(forKey: "rating") != nil)
            {
                ratingView.rating = Float("\(profileDict.value(forKey: "rating")!)")!
            }
            else
            {
                ratingView.rating = 0
            }
        }
       
        cell.selectionStyle = .none
        return cell
    }
    
    @objc @IBAction func detailBtnTapped(_ sender: UIButton)
    {
        let vc = UIStoryboard(name: "TabbarStoryboard", bundle: nil).instantiateViewController(withIdentifier: "DoctorsProfileViewController") as! DoctorsProfileViewController
       
        vc.docId = "\(((dataDic.value(forKey: "appointment_detail") as! NSDictionary).value(forKey: "doctor_detail") as! NSDictionary).value(forKey: "id_user")!)"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK:- Prescription Detail cell
    
    func cellForPrescriptionDescription(_ cell: PrescriptionTableViewCell, indexPath: IndexPath) -> UITableViewCell
    {
        let descriptionLabel = cell.viewWithTag(151) as! UILabel
        descriptionLabel.text = "\(dataDic.value(forKey: "prescription")!)"
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK:- Prescribed drugs
    func cellForPrescribedDrugs(_ cell: PrescribedDrugTableViewCell, indexPath: IndexPath) -> UITableViewCell
    {
        let drugNameLabel = cell.viewWithTag(122) as! UILabel
        let drugPriceLabel = cell.viewWithTag(123) as! UILabel
        let drugQuantityLabel = cell.viewWithTag(125) as! UILabel
        let drugTimeLabel = cell.viewWithTag(127) as! UILabel
        let drugDosageLabel = cell.viewWithTag(129) as! UILabel
        let remarkLabel = cell.viewWithTag(130) as! UILabel
        drugQuantityLabel.textAlignment = .left
        drugTimeLabel.textAlignment = .center
        drugDosageLabel.textAlignment = .center
        
        if let x = dataDic.value(forKey: "drug") as? NSArray
        {
            if let y = (x.object(at: indexPath.row) as! NSDictionary).value(forKey: "drug_name") as? String
            {
                drugNameLabel.text = y
            }
            else
            {
                drugNameLabel.text = "NA"
            }
            
            if let y = (x.object(at: indexPath.row) as! NSDictionary).value(forKey: "price_per_piece") as? String
            {
                drugPriceLabel.text = "$\((Double("\(y)")! * Double("\((x.object(at: indexPath.row) as! NSDictionary).value(forKey: "quantity")!)")!))"
            }
            else
            {
                drugPriceLabel.text = "NA"
            }
            
            if let y = (x.object(at: indexPath.row) as! NSDictionary).value(forKey: "quantity") as? String, let x = (x.object(at: indexPath.row) as! NSDictionary).value(forKey: "days") as? String
            {
                drugQuantityLabel.text = "\(y) Tablets\n\(x) Days"
                
                drugQuantityLabel.adjustsFontSizeToFitWidth = true
            }
            else
            {
                drugQuantityLabel.text = "NA"
            }
            
            if let y = (x.object(at: indexPath.row) as! NSDictionary).value(forKey: "best_time") as? String
            {
                drugTimeLabel.text = y
            }
            else
            {
                drugTimeLabel.text = "NA"
            }
            
            if let y = (x.object(at: indexPath.row) as! NSDictionary).value(forKey: "dosage") as? String
            {
                drugDosageLabel.text = y
            }
            else
            {
                drugDosageLabel.text = "NA"
            }
            
            if let y = (x.object(at: indexPath.row) as! NSDictionary).value(forKey: "remarks") as? String
            {
                remarkLabel.text = y
            }
            else
            {
                remarkLabel.text = "NA"
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK:- Question Cell
    func cellForQuestionAsking(_ cell: QuestionsTableViewCell, indexPath: IndexPath) -> UITableViewCell
    {
        let questionLabel = cell.viewWithTag(162) as! UILabel
        let noBtn = cell.viewWithTag(163) as! UIButton
        let yesBtn = cell.viewWithTag(164) as! UIButton
        
        if indexPath.section == 2
        {
            questionLabel.text = "DO YOU WANT US TO ARRANGE THE MEDICNINE"
            
            yesBtn.removeTarget(self, action: #selector(LabTestButton(_:)), for: .touchUpInside)
            yesBtn.addTarget(self, action: #selector(DrugButton(_:)), for: .touchUpInside)
            noBtn.removeTarget(self, action: #selector(LabTestButton(_:)), for: .touchUpInside)
            noBtn.addTarget(self, action: #selector(DrugButton(_:)), for: .touchUpInside)
        }
        else
        {
            questionLabel.text = "DO YOU WANT US TO ARRANGE THE LAB TEST"
            
            yesBtn.removeTarget(self, action: #selector(DrugButton(_:)), for: .touchUpInside)
            yesBtn.addTarget(self, action: #selector(LabTestButton(_:)), for: .touchUpInside)
            noBtn.removeTarget(self, action: #selector(DrugButton(_:)), for: .touchUpInside)
            noBtn.addTarget(self, action: #selector(LabTestButton(_:)), for: .touchUpInside)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK:- Lab test name cell
    func cellLabTestName(_ cell: PrescribedLabTestTableViewCell, indexPath: IndexPath) -> UITableViewCell
    {
        let labTestNameLabel = cell.viewWithTag(172) as! UILabel
        let labTestPriceLabel = cell.viewWithTag(173) as! UILabel
        
        if let dict = dataDic.value(forKey: "lab_test") as? NSArray{
            
            labTestNameLabel.text = "\((dict.object(at: indexPath.row) as! NSDictionary).value(forKey: "lab_test_name")!)"
            labTestPriceLabel.text = "$\((dict.object(at: indexPath.row) as! NSDictionary).value(forKey: "price")!)"
        }
        else
        {
            labTestNameLabel.text = "NA"
            labTestPriceLabel.text = "NA"
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK:- payment button cell
    func cellForPaymentButton(_ cell: PaymentTableViewCell, indexPath: IndexPath) -> UITableViewCell
    {
        let button = cell.viewWithTag(1) as! UIButton
        button.addTarget(self, action: #selector(paymentBtn(_:)), for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK:- Total Amount Cell
    func cellForTotalAmount(_ cell: TotalAmountTableViewCell, indexPath: IndexPath) -> UITableViewCell
    {
        let labTestNameLabel = cell.viewWithTag(182) as! UILabel
        let labTestPriceLabel = cell.viewWithTag(183) as! UILabel
        labTestNameLabel.text = "Total"
        
        labTestPriceLabel.text = "$\(calculatePrice())"
        cell.selectionStyle = .none
        return cell
    }
    
    
    func calculatePrice() -> Double
    {
        var total = 0.0
      
        if(dataDic.value(forKey: "lab_test") != nil && dataDic.value(forKey: "lab_test") is NSArray) && is_lab_test
        {
            for i in 0..<(dataDic.value(forKey: "lab_test") as! NSArray).count
            {
                total = total + Double("\(((dataDic.value(forKey: "lab_test") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "price")!)")!
            }
        }
        
        if(dataDic.value(forKey: "drug") != nil && dataDic.value(forKey: "drug") is NSArray) && is_drug_yes
        {
            for i in 0..<(dataDic.value(forKey: "drug") as! NSArray).count
            {
                total = total + (Double("\(((dataDic.value(forKey: "drug") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "price_per_piece")!)")! * Double("\(((dataDic.value(forKey: "drug") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "quantity")!)")!)
            }
        }
        
        
        return total
    }
    
    
    //MARK:- button handling
    
    @IBAction func paymentBtn(_ sender:UIButton)
    {
        let story = UIStoryboard(name: "TabbarStoryboard", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "SelectPaymentMethodViewController") as! SelectPaymentMethodViewController
        
        vc.id_appt_forPayment = Int("\((dataDic.value(forKey: "appointment_detail") as! NSDictionary).value(forKey: "id_appointment")!)")!
        vc.price_forPayment = Int(Double("\(calculatePrice())")!)
        vc.from = "extended"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func DrugButton(_ sender:UIButton)
    {
        if(sender.tag == 163)
        {
            is_drug_yes = false
             self.prescribedTableView.reloadData()
        }
        else
        {
            is_drug_yes = true
            self.prescribedTableView.reloadData()
            self.prescribedTableView.scrollToRow(at: IndexPath(row: 0, section: 5), at: UITableViewScrollPosition.bottom, animated: false)
        }
    }
    
    
    @IBAction func LabTestButton(_ sender:UIButton)
    {
        if(sender.tag == 163)
        {
            is_lab_test = false
            self.prescribedTableView.reloadData()
        }
        else
        {
            is_lab_test = true
            self.prescribedTableView.reloadData()
            self.prescribedTableView.scrollToRow(at: IndexPath(row: 0, section: 5), at: UITableViewScrollPosition.bottom, animated: false)
        }
    }
    
    
    
    //MARK:- webservice
    func history_detail()
    {
        supportingfuction.hideProgressHudInView(view: self)
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
      //  dict.setObject("\(dataDic.value(forKey: "id_doctor")!)", forKey: "id_user" as NSCopying)
        dict.setObject("\(dataDic.value(forKey: "id_appointment")!)", forKey: "id_appointment" as NSCopying)
        dict.setValue("patient", forKey: "user_type")
        let apiSniper = APISniper()
        
        
        apiSniper.getDataFromWebAPI(WebAPI.history_detail,dict, {(operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    print(dataFromServer)
                    self.dataDic = (dataFromServer.value(forKey: "data") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    self.prescribedTableView.reloadData()
                }
                else if(dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
                }
                else
                {
                    if dataFromServer.object(forKey: "message") != nil
                    {
                        supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                    }
                }
            }
        }) { (operation, error) in
            supportingfuction.hideProgressHudInView(view: self)
            print(error.localizedDescription)
            
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        }
    }
    
    
    
}
