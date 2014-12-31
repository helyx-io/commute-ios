//
//  COMenuTableViewCell.swift
//  Commute
//
//  Created by Alexis Kinsella on 30/12/2014.
//  Copyright (c) 2014 Helyx.io. All rights reserved.
//

import UIKit
import SwiftyJSON

class COMenuItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuItemLabel: UILabel!

    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        self.menuItemLabel.textColor = !selected ? UIColor.lightTextColor() : UIColor.blackColor()
        self.backgroundColor = !selected ? UIColor.clearColor() : UIColor(red:1, green:1, blue:1, alpha:0.25)
    }
    
    func updateWithMenuItem(name:String) {
        self.menuItemLabel.text = name
    }
    
}
