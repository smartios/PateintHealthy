//
//  MedicineHeaderView.swift
//  VIsionPro
//
//  Created by SS042 on 22/03/18.
//  Copyright © 2018 SS042. All rights reserved.
//

import UIKit

protocol ShowHideMedicineSummary {
    func showHideMedicineSummary(isShow:Bool)
}

class MedicineHeaderView: UIView {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentView: UIView!
    var delegate:ShowHideMedicineSummary!
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override init(frame: CGRect) {
        print("override init(frame: CGRect) ")
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("required init?(coder aDecoder: NSCoder)")
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MedicineHeaderView", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
        
    }
    @IBAction func showBtnClicked(_ sender: UIButton) {
        
        if sender.isSelected{
            sender.isSelected = false
            delegate.showHideMedicineSummary(isShow: false)
        }else{
            sender.isSelected = true
            delegate.showHideMedicineSummary(isShow: true)
        }
    }
    
}
