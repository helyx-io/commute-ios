//
//  CommuteTests.swift
//  CommuteTests
//
//  Created by Alexis Kinsella on 28/12/2014.
//  Copyright (c) 2014 Alexis Kinsella. All rights reserved.
//

import Alamofire
import SwiftyJSON

import UIKit
import XCTest

class CommuteTests: XCTestCase {

    func testShouldGetStops() {
        // This is an example of a performance test case.

        Alamofire.request(.GET, "http://localhost:9000/api/agencies/RATP_GTFS_FULL/stops", parameters: nil)
        .response { (request, response, data, error) in
            println(data!)
            let json = SwiftyJSON.JSON(data: data as NSData!)

            println(json[0])

        }

        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
