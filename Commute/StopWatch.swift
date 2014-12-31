//
//  StopWatch.swift
//  Commute
//
//  Created by Alexis Kinsella on 31/12/2014.
//  Copyright (c) 2014 Helyx.io. All rights reserved.
//

import CoreFoundation

class StopWatch {
    
    let startTime:CFAbsoluteTime
    var endTime:CFAbsoluteTime?
    
    init() {
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    func stop() -> CFAbsoluteTime {
        endTime = CFAbsoluteTimeGetCurrent()
        
        return duration!
    }
    
    var duration:CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
}