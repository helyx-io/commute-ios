//
//  ViewController.swift
//  Commute
//
//  Created by Alexis Kinsella on 28/12/2014.
//  Copyright (c) 2014 Alexis Kinsella. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation

class COAroundMeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var locationStatus : NSString = "Not Started"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftDrawerButton = MMDrawerBarButtonItem(target:self, action:"leftDrawerButtonPress")
        leftDrawerButton.tintColor = UIColor.darkGrayColor()
        
        self.navigationItem.setLeftBarButtonItem(leftDrawerButton, animated: true)
        
        
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self
        self.locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager!.requestWhenInUseAuthorization()
        
        self.mapView.mapType = MKMapType.Standard
    }
    
    func leftDrawerButtonPress() {
        self.drawerController.toggleDrawerSide(.Left, animated: true) { (Bool) -> Void in }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager!.stopUpdatingLocation()
        if error != nil {
            print(error)
        }
    }
    
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            var shouldIAllow = false
            
            switch status {
            case CLAuthorizationStatus.Restricted:
                locationStatus = "Restricted Access to location"
            case CLAuthorizationStatus.Denied:
                locationStatus = "User denied access to location"
            case CLAuthorizationStatus.NotDetermined:
                locationStatus = "Status not determined"
            default:
                locationStatus = "Allowed to location Access"
                shouldIAllow = true
            }
            if (shouldIAllow == true) {
                println("Location to Allowed")
                // Start location services
                locationManager.startUpdatingLocation()
                self.mapView.showsUserLocation = true
            } else {
                println("Denied access: \(locationStatus)")
            }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let lastLocation = locations.last as CLLocation
        let accuracy = lastLocation.horizontalAccuracy
        println("Received location \(lastLocation) with accuracy \(accuracy)")
        
        if accuracy < 100.0 {
            let span = MKCoordinateSpan(latitudeDelta: 0.14, longitudeDelta: 0.14)
            let region = MKCoordinateRegion(center: lastLocation.coordinate, span: span)
            
            self.mapView.setRegion(region, animated: true)
            
            self.locationManager!.stopUpdatingLocation()
        }
    }
    
}
