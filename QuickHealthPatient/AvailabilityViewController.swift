//
//  AvailabilityViewController.swift
//  DAWProvider
//
//  Created by SS142 on 22/02/17.
//
//

import UIKit

class AvailabilityViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance{
    
    @IBOutlet weak var tableView: UITableView!
    
    var calSelectedDate = Date()
    var DateString = ""
    var selected_dateString = ""
   
    var currentTime = NSDate()
    var doc_id = ""
    var invalidTime = false
    var SlotListArr = NSMutableArray()
    var selectedSlot = ""
    var selectedSlot_id = ""
    var date: DateFormatter = DateFormatter()
    var allBookedDateArray = NSMutableArray()
    var showAvailableSlotList = NSMutableArray()
    var slotIDtoSend = ""
    
    //  appointment Data
    var ApptSend_serviceID = ""
    var ApptSend_doctorsID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date.timeStyle = DateFormatter.Style.short
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        selectedSlot_id = ""
        SlotListArr.removeAllObjects()
    }

    //MARK: TableView Delegate Method
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 1
        }else if section == 1
        {
            if showAvailableSlotList.count > 0
            {
               return showAvailableSlotList.count + 1
            }else
            {
           
              return 0
                
            }
           
        }else
        {
           return 1
        }
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : UITableViewCell!
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell")
                let calendarHeader = cell.viewWithTag(1)! as UIView
                let calDownHeader = cell.viewWithTag(2)! as UIView
                let calendar = cell.viewWithTag(3)! as! FSCalendar
                calendarHeader.layer.borderWidth = 1.0
                calendarHeader.layer.borderColor = UIColor.clear.cgColor
                calDownHeader.layer.borderWidth = 1.0
                calDownHeader.layer.borderColor = UIColor.clear.cgColor
                
                calendar.scopeGesture.isEnabled = false
                calendar.scrollEnabled = false
                calendar.dataSource = self
                calendar.delegate = self
                //calendar.allowMultipleSelect = false
                calendar.allowsMultipleSelection = false
                calendar.bookedDates = self.allBookedDateArray
                
                let leftArrow = calendarHeader.viewWithTag(-1) as! UIButton
//
                leftArrow.isHidden = true
//
//                for subview in calendar.subviews[0].subviews[0].subviews
//                {
//                    if subview is UICollectionView
//                    {
//                        let collectionView = subview as! UICollectionView
//                            if collectionView.contentOffset.x == 0
//                            {
//                                leftArrow.isHidden = true
//                            }
//                    }
//                }
                
                
            }
        }else if indexPath.section == 1
        {
          if indexPath.row == 0
          {
            cell = tableView.dequeueReusableCell(withIdentifier: "headingCell")
            }else
          {
            //slotCell
             cell = tableView.dequeueReusableCell(withIdentifier: "slotCell")
            let slotNameLbl = cell.viewWithTag(1) as! UILabel
            let tickBtn = cell.viewWithTag(2) as! UIButton
            if showAvailableSlotList.count > 0
            {
                if let x = ((showAvailableSlotList.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "name") as? String)
                {
                    slotNameLbl.text = x.lowercased()
                }
            }
            
            if slotIDtoSend == (showAvailableSlotList.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "id_available_slot") as! String
            {
               tickBtn.isHidden = false
                
                slotNameLbl.textColor = CommonValidations.UIColorFromRGB(rgbValue: 0x008080)
            }
            else
            {
                tickBtn.isHidden = true
                
                slotNameLbl.textColor = UIColor.black
            }
            }
        }else
        {
           cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 350
        }else if indexPath.section == 1
        {
            return 50
        }else
        {
             return 64
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 1 && indexPath.row != 0
        {
            print(indexPath.row)
            if let x = (showAvailableSlotList.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "id_available_slot") as? String
            {
                 slotIDtoSend = x
            }
        }
        
        tableView.reloadData()
    }
    
    /**
     */
    var shouldShowEventDot = false
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    deinit {
        print("\(#function)")
    }
    
    @objc
    func todayItemClicked(sender: AnyObject) {
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath)
        let calendar = cell?.viewWithTag(3)! as! FSCalendar
        calendar.setCurrentPage(Date(), animated: false)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -32)
        
        let d = NSDate()
        let dStr = formatter.string(from: d as Date)
        let dateStr = formatter.string(from: date)
        
        if dateStr == dStr  {
            // calendar.appearance.eventOffset = top
            return 1
        }
        else    {
            return 0
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
        return nil
    }
    
    //MARK: @IBAction
    
 
    
    @IBAction func changeMonthButtonClicked(_ sender: UIButton) {
       
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath)
        let calendar = cell?.viewWithTag(3)! as! FSCalendar
         calendar.delegate = self
        
        let leftArrow = (cell?.viewWithTag(1)! as! UIView).viewWithTag(-1) as! UIButton

        for subview in calendar.subviews[0].subviews[0].subviews
        {
            if subview is UICollectionView
            {
                let collectionView = subview as! UICollectionView
                if sender.tag == -1
                {
                    if collectionView.contentOffset.x == 0
                    {
                        
                    }else
                    {
                        collectionView.contentOffset.x = collectionView.contentOffset.x - collectionView.frame.size.width
                    }
                }
                else
                {
                    leftArrow.isHidden = false

                    return
                    collectionView.contentOffset.x = collectionView.contentOffset.x + collectionView.frame.size.width
                }
                
                if collectionView.contentOffset.x == 0
                {
                    leftArrow.isHidden = true
                }
                else
                {
                    leftArrow.isHidden = false
                }
            }
        }
        
    }
    
    func calendar(_ calendar: FSCalendar, hasEventFor date: Date) -> Bool {
        let dateString = NSDate()
        if dateString == NSDate()
        {
            shouldShowEventDot = true
        }
        return shouldShowEventDot
    }
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate let formatterNew: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    func minimumDate(for calendar: FSCalendar) -> Date
    {
        let currentDate = Date()
        return currentDate
    }
    
//    func maximumDate(for calendar: FSCalendar) -> Date {
//        let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
//        var components = cal.components([.day, .month, .year, .hour , .minute, .second ], from: Date())
//        components.month = components.month! + 1
//        let d = cal.date(from: components)!
//        return d
//    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        DateString = ""
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-mm-dd"
        calSelectedDate = date;
        print(calSelectedDate);
        selected_dateString = ("\(self.formatter.string(from: date))")
        let selected_date_string = ("\(self.formatterNew.string(from: date))")
        
        if  DateString != ""
        {
            DateString = ""
        }else{
            formatter.dateFormat = "dd-MMM-yyyy"
            DateString = formatter.string(from: date)
            selected_dateString = ("\(formatter.string(from: date))")
        }
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        //calendar.reloadData()
        
        print(selected_date_string)
        //getting datestring from selected date to get its slot array
     
         for i in 0 ..< self.allBookedDateArray.count
         {
            showAvailableSlotList.removeAllObjects()
            if selected_date_string == "\((self.allBookedDateArray.object(at: i) as! NSDictionary).value(forKey: "available_date")!)"
            {
              
                print((allBookedDateArray.object(at: i) as! NSDictionary).object(forKey: "slot_list") as! NSArray)
                showAvailableSlotList = ((allBookedDateArray.object(at: i) as! NSDictionary).object(forKey: "slot_list") as! NSArray).mutableCopy() as! NSMutableArray
                
                tableView.reloadData()
                break
                
            }else
            {
                 tableView.reloadData()
               //supportingfuction.showMessageHudWithMessage(message: "No doctor available for selected date", delay: 2.0)
            }
           
        }
    }
    ///
    
    //MARK:- Buttons
    @IBAction func menuButtonClicked(sender: AnyObject) {
        self.view.endEditing(true)
        onSlideMenuButtonPressed(sender as! UIButton)
    }
    
    @IBAction func cancelBtnTapped(sender: UIButton){
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        if selected_dateString == ""
        {
            supportingfuction.showMessageHudWithMessage(message: "Please select date", delay: 2.0)
            return
        }else if slotIDtoSend == ""
        {
            supportingfuction.showMessageHudWithMessage(message: "Please select available time slot", delay: 2.0)
            return
        }else
        {
            if(!appDelegate.hasConnectivity())
            {
                supportingfuction.showMessageHudWithMessage(message: NoInternetConnection as NSString, delay: 2.0)
            }
            else
            {
               // getUserData()
            }
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectPatientViewController") as! SelectPatientViewController
           
             vc.ApptSend_slotIDtoSend = slotIDtoSend
            vc.ApptSend_serviceID = ApptSend_serviceID
            vc.ApptSend_doctorsID = ApptSend_doctorsID
            self.navigationController?.pushViewController(vc, animated: true)
            print(selected_dateString)
            print(slotIDtoSend)
            print(ApptSend_serviceID)
            print(ApptSend_doctorsID)
        }
    }

}



