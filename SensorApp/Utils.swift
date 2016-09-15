//
//  Utils.swift
//  SensorApp
//
//  Copyright © 2016 Zühlke Engineering AG. All rights reserved.
//

import UIKit

/**
 The purpose of the `Utils` class is to provide helper methods that could be useful to other classes
 */
class Utils {
    
    ///A datFormatter that helps creating a datestring that the backend accepts
    static func dateFormatter()-> NSDateFormatter{
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        return formatter
    }
    
    ///A dateFormatter that helps creating a short date string for the UI 
    static func dateFormatterShort()-> NSDateFormatter{
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }
    
}
