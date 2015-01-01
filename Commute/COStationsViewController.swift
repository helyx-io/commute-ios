//
//  ViewController.swift
//  Commute
//
//  Created by Alexis Kinsella on 28/12/2014.
//  Copyright (c) 2014 Alexis Kinsella. All rights reserved.
//


import UIKit

class COStationsViewController: COBaseStationsViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    var resultsTableController: COResultsStationsViewController!

    var searchController: UISearchController!;

    var stations:Array<JSON> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftDrawerButton = MMDrawerBarButtonItem(target:self, action:"leftDrawerButtonPress")
        leftDrawerButton.tintColor = UIColor.whiteColor()
        
        let rightDrawerButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target:self, action:"rightButtonPress")
        rightDrawerButton.tintColor = UIColor.whiteColor()
        
        self.navigationItem.setLeftBarButtonItem(leftDrawerButton, animated: true)
        self.navigationItem.setRightBarButtonItem(rightDrawerButton, animated: true)
        
        self.resultsTableController = COResultsStationsViewController()
        
        self.searchController = UISearchController(searchResultsController: self.resultsTableController)
        
        self.searchController.searchResultsUpdater = self
        
        self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
        
        self.searchController.searchBar.delegate = self;
        self.searchController.searchBar.scopeButtonTitles = ["Tout", "Bus", "Métro", "RER"];
        
        self.searchController.searchBar.barTintColor = UIColor(rgba: "#F0F0F0")
        self.searchController.searchBar.layer.borderWidth = 1
        self.searchController.searchBar.layer.borderColor = self.searchController.searchBar.barTintColor?.CGColor
        self.searchController.searchBar.tintColor = UIColor(rgba: "#50748B")
        
        self.tableView.tableHeaderView = self.searchController.searchBar;
        
        self.definesPresentationContext = true
        
        self.loadData()
    }
    
    func leftDrawerButtonPress() {
        self.drawerController.toggleDrawerSide(.Left, animated: true) { (Bool) -> Void in }
    }
    
    func rightButtonPress() {
        self.tableView.setContentOffset(CGPoint(x:0, y:-20 - self.navigationController!.navigationBar.bounds.size.height), animated: true)
    }
    
    func loadData() {
        
        request(.GET, "http://192.168.0.12:9000/api/agencies/RATP_GTFS_FULL/stations?locations=0", parameters: nil)
            .response { (request, response, data, error) in
                
                let sw = StopWatch()
                
                let json = JSON(data: data as NSData!)
                
                println("Transforming to JSON took \(sw.stop()) seconds.")
                
                self.stations = json.array!
                
                self.computeViewModels(self.stations, searchText: self.searchController.searchBar.text)
                
                println("Filtering stations took \(sw.stop()) seconds.")
                
                self.tableView.reloadData()
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.resultsTableController.updateWithSearchTerm(self.stations, searchText: searchController.searchBar.text)
    }
    
}
