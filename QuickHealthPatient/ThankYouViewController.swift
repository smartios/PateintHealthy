//
//  ThankYouViewController.swift
//  QuickHealthPatient
//
//  Created by SS114 on 06/02/18.
//  Copyright © 2018 SL161. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerCell: UITableViewCell!
    @IBOutlet var profileCell: UITableViewCell!
    var tapGesture = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.layer.cornerRadius = 12

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        
        self.view.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }

    /// Hide keyboard when user taps anywhere on the screen.
    @objc func hideKeyboard()
    {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //    MARK: - TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        Bundle.main.loadNibNamed("thankYouCells", owner: self, options: nil)
        
        var cell:UITableViewCell!
        
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
            if cell == nil
            {
                cell = headerCell
                headerCell = nil
            }
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "profileCell")
            if cell == nil
            {
                cell = profileCell
                profileCell = nil
            }
            
            let floatRatingView = cell.viewWithTag(3) as! FloatRatingView
            
            let detailButton = cell.viewWithTag(11) as! UIButton

            let lineLbl = cell.viewWithTag(-111) as! UILabel

            detailButton.layer.cornerRadius = 4.0
            detailButton.layer.borderColor = CommonValidations.UIColorFromRGB(rgbValue: 0x008080).cgColor
            detailButton.layer.borderWidth = 1.0
            
            
            floatRatingView.emptyImage = #imageLiteral(resourceName: "StarGrey")
            floatRatingView.fullImage = #imageLiteral(resourceName: "StarOrange")
            // Optional params

            floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
            floatRatingView.maxRating = 5
            floatRatingView.minRating = 0
            floatRatingView.rating = 0
            floatRatingView.editable = false
            floatRatingView.halfRatings = false
            floatRatingView.floatRatings = false
            
            if indexPath.row == 2
            {
                lineLbl.isHidden = true
            }
            else
            {
                lineLbl.isHidden = false
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @IBAction func CrossTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
}
