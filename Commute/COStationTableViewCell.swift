//
//  StopViewControllerCell.swift
//  Commute
//
//  Created by Alexis Kinsella on 29/12/2014.
//  Copyright (c) 2014 Alexis Kinsella. All rights reserved.
//

import Foundation

//
//  ViewController.swift
//  Commute
//
//  Created by Alexis Kinsella on 28/12/2014.
//  Copyright (c) 2014 Alexis Kinsella. All rights reserved.
//


import UIKit
import SwiftyJSON

class COStationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stationNameLabel: UILabel!
    
    func updateWithStation(station: JSON) {
        stationNameLabel.text = station["name"].stringValue
    }
    
}
