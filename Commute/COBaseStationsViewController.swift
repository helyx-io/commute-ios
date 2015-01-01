//
//  ViewController.swift
//  Commute
//
//  Created by Alexis Kinsella on 28/12/2014.
//  Copyright (c) 2014 Alexis Kinsella. All rights reserved.
//


import UIKit

class COBaseStationsViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct Constants {
        struct Nib {
            static let name = "COStationTableViewCell"
        }
        
        struct TableViewCell {
            static let identifier = "StationCell"
        }
    }
    
    let jobQueue:dispatch_queue_t = dispatch_queue_create("STATION_JOB_QUEUE", nil)
    
    var filteredStations:Array<JSON> = []
    var filteredStationsBySection:[String:Array<JSON>] = [:]
    var sectionTitles:Array<String> = []
    
    var stationsTableBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.sectionIndexColor = UIColor(rgba: "#345d79")
        
        self.configureStationsTableBackgroundView()
     
        let nib = UINib(nibName: Constants.Nib.name, bundle: nil)
        
        // Required if our subclasses are to use: dequeueReusableCellWithIdentifier:forIndexPath:
        self.tableView.registerNib(nib, forCellReuseIdentifier: Constants.TableViewCell.identifier)
    }
    
    func configureStationsTableBackgroundView() {
        // Display a message when the table is empty
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        
        messageLabel.text = "No data is currently available.\nPlease pull down to refresh."
        messageLabel.textColor = UIColor.darkTextColor()
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = NSTextAlignment.Center
        messageLabel.font = UIFont.systemFontOfSize(16)
        messageLabel.sizeToFit()
        
        self.stationsTableBackgroundView = messageLabel
    }
    
    func updateWithSearchTerm(stations: Array<JSON>, searchText: String) {
        dispatch_async(jobQueue) {
            self.computeViewModels(stations, searchText: searchText)
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    func filterStations(stations:Array<JSON>, searchText: String) -> Array<JSON> {
        return stations
    }

    func computeViewModels(stations: Array<JSON>, searchText: String) {
        
        self.filteredStations = self.filterStations(stations, searchText: searchText)
        
        self.filteredStationsBySection = $.groupBy(self.filteredStations, function: { (station) -> String in
            let stationName = station["name"].stringValue
            return stationName.substringToIndex(advance(stationName.startIndex, 1))
        })
        
        self.sectionTitles = self.filteredStationsBySection.keys.array.sorted({ (sectionTitle1:String, sectionTitle2:String) -> Bool in
            sectionTitle1.compare(sectionTitle2, options: NSStringCompareOptions.CaseInsensitiveSearch) == NSComparisonResult.OrderedAscending
        })
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredStationsBySection[self.sectionTitles[section]]!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.TableViewCell.identifier, forIndexPath: indexPath) as COStationTableViewCell
        
        let station = self.filteredStationsBySection[self.sectionTitles[indexPath.section]]![indexPath.row] as JSON
        cell.updateWithStation(station)
        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if self.sectionTitles.count > 0 {
            self.tableView.backgroundView = nil;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine;
        } else {
            self.tableView.backgroundView = self.stationsTableBackgroundView;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        }
        
        return self.sectionTitles.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }
    
//    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
//        return self.filteredStations.count > 12 || self.sectionTitles.count > 5 ? self.sectionTitles : []
//    }
    
}
