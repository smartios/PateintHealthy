//
//  MedicineSummaryViewController.swift
//  VIsionPro
//
//  Created by SS042 on 22/03/18.
//  Copyright © 2018 SS042. All rights reserved.
//

import UIKit

class MedicineSummaryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!{
        didSet{
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.rowHeight = 100
            self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
            self.tableView.register(UINib(nibName: "MedicineNameCell", bundle: nil), forCellReuseIdentifier: "MedicineNameCell")
        }
    }
    
    let medicineData:NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Midicine"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return medicineData.count + 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineNameCell", for: indexPath) as! MedicineNameCell
        return cellForMedicineList(cell: cell, indexPath: indexPath)
    }
    
    func cellForMedicineList(cell:MedicineNameCell,indexPath:IndexPath)->MedicineNameCell{
        cell.medicineName.text = "Paracetamol"
        cell.quantity.text = "30 Tablets"
        return cell
    }

}
