//
//  MedicineNameCell.swift
//  VIsionPro
//
//  Created by SS042 on 22/03/18.
//  Copyright © 2018 SS042. All rights reserved.
//

import UIKit

class MedicineNameCell: UITableViewCell {

    @IBOutlet var medicineName: UILabel!
    @IBOutlet var quantity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
