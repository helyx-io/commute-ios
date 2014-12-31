//
//  UIViewControllerExtension.swift
//  Commute
//
//  Created by Alexis Kinsella on 29/12/2014.
//  Copyright (c) 2014 Helyx.io. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var drawerController: MMDrawerController {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        return appDelegate.window?.rootViewController as MMDrawerController
    }
    
}