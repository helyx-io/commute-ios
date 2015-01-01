//
//  ViewController.swift
//  Commute
//
//  Created by Alexis Kinsella on 28/12/2014.
//  Copyright (c) 2014 Alexis Kinsella. All rights reserved.
//


import UIKit
import Alamofire
import Dollar

class COResultsStationsViewController: COBaseStationsViewController {

    override func filterStations(stations:Array<JSON>, searchText: String) -> Array<JSON> {
        return searchText.isEmpty ? stations : stations.filter({ (station) -> Bool in
            let stationName = station["name"].stringValue
            
            return stationName.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil
        })
    }

}
