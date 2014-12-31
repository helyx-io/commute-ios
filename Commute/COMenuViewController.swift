//
//  COMenuViewController.swift
//  Commute
//
//  Created by Alexis Kinsella on 30/12/2014.
//  Copyright (c) 2014 Helyx.io. All rights reserved.
//

import Foundation

class COMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuItemsTableView: UITableView!

    let menuItems = ["Autour de moi", "Stations"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"blurred-background")!)
        self.menuItemsTableView.backgroundColor = UIColor.clearColor()
     }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        let centerViewController: UINavigationController = self.drawerController.centerViewController as UINavigationController
        if centerViewController.topViewController is COStationsViewController {
            self.menuItemsTableView.selectRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.Top)
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuItemCell", forIndexPath: indexPath) as COMenuItemTableViewCell
        
        let menuItem = self.menuItems[indexPath.row]
        
        cell.updateWithMenuItem(menuItem)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if indexPath.row == 0 {

            self.drawerController.centerViewController = storyboard.instantiateViewControllerWithIdentifier("PlanNC") as UIViewController
        }
        else if indexPath.row == 1 {
            self.drawerController.centerViewController = storyboard.instantiateViewControllerWithIdentifier("StationsNC") as UIViewController
        }
        
        self.drawerController.closeDrawerAnimated(true, completion: { (Bool) -> Void in
        })
    }
    
}