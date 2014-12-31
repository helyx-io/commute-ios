//
//  DollarExtension.swift
//  Commute
//
//  Created by Alexis Kinsella on 28/12/2014.
//  Copyright (c) 2014 Alexis Kinsella. All rights reserved.
//

import Dollar

extension Dollar.$ {
    
    public class func groupBy<T, U: Equatable>(array: [T], function: (T) -> U) -> [U: Array<T>] {
        var result = [U: Array<T>]()
        for element in array {
            let key = function(element)
            if var elements = result[key] {
                elements.append(element)
                result[key] = elements
            } else {
                result[key] = [element]
            }
        }
        return result
    }
    
}