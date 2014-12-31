//
//  ViewController.swift
//  Commute
//
//  Created by Alexis Kinsella on 28/12/2014.
//  Copyright (c) 2014 Alexis Kinsella. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON
import Dollar

class COStationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var stationsTableView: UITableView!

    let jobQueue:dispatch_queue_t = dispatch_queue_create("STATION_JOB_QUEUE", nil)

    var stations:Array<JSON> = []
    var filteredStations:Array<JSON> = []
    var filteredStationsBySection:[String:Array<JSON>] = [:]
    var sectionTitles:Array<String> = []
    
    var stationsTableBackgroundView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stationsTableView.sectionIndexColor = UIColor(rgba: "#345d79")
        
        self.configureStationsTableBackgroundView()
        
        let leftDrawerButton = MMDrawerBarButtonItem(target:self, action:"leftDrawerButtonPress")
        leftDrawerButton.tintColor = UIColor.whiteColor()
        
        self.navigationItem.setLeftBarButtonItem(leftDrawerButton, animated: true)
        
        self.loadData()
    }
    
    func leftDrawerButtonPress() {
        self.drawerController.toggleDrawerSide(.Left, animated: true) { (Bool) -> Void in }
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
    
    func loadData() {
        
        Alamofire.request(.GET, "http://192.168.0.12:9000/api/agencies/RATP_GTFS_FULL/stations?locations=0", parameters: nil)
            .response { (request, response, data, error) in
            
                let sw = StopWatch()
                
                let json = SwiftyJSON.JSON(data: data as NSData!)

                println("Transforming to JSON took \(sw.stop()) seconds.")

                self.stations = json.array!

                self.filterStations(self.searchBar.text)
                
                println("Filtering stations took \(sw.stop()) seconds.")
       }
    }
   
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredStationsBySection[self.sectionTitles[section]]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StationCell", forIndexPath: indexPath) as COStationTableViewCell
        
        let station = self.filteredStationsBySection[self.sectionTitles[indexPath.section]]![indexPath.row] as JSON
        cell.updateWithStation(station)

        return cell
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if self.sectionTitles.count > 0 {
            self.stationsTableView.backgroundView = nil;
            self.stationsTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine;
        } else {
            self.stationsTableView.backgroundView = self.stationsTableBackgroundView;
            self.stationsTableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        }
        
        return self.sectionTitles.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return self.filteredStations.count > 12 || self.sectionTitles.count > 5 ? self.sectionTitles : []
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterStations(searchBar.text)
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
    }
    
    func filterStations(searchText: String) {

        dispatch_async(jobQueue) {

            self.filteredStations = searchText.isEmpty ? self.stations : self.stations.filter({ (station) -> Bool in
                let stationName = station["name"].stringValue

                return stationName.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil
            })
            
            self.filteredStationsBySection = $.groupBy(self.filteredStations, function: { (station) -> String in
                let stationName = station["name"].stringValue
                return stationName.substringToIndex(advance(stationName.startIndex, 1))
            })
            
            self.sectionTitles = self.filteredStationsBySection.keys.array.sorted({ (sectionTitle1:String, sectionTitle2:String) -> Bool in
                sectionTitle1.compare(sectionTitle2, options: NSStringCompareOptions.CaseInsensitiveSearch) == NSComparisonResult.OrderedAscending
            })

            dispatch_async(dispatch_get_main_queue()) {
                self.stationsTableView.reloadData()
            }
            
        }
        
    }

}
