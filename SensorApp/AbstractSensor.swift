//
//  AbstractSensor.swift
//  SensorApp
//
//  Copyright © 2016 Zühlke Engineering AG. All rights reserved.
//

import AVFoundation
/**
 The purpose of the `AbstractSensor` class is to provide variables and methods to DeviceSensor classes in respect to the DRY principle
 */
public class AbstractSensor: NSObject {

    ///A fileWiter is used to write read data to cache
    var fileWriter: FileWriterService?
    
    ///A dateformatter to write the date of the reading to cache as a formatted string
    public let dateFormatter = Utils.dateFormatter()
    
    ///A instance of NSUserDefaults to persist settings of the app
    let defaults = UserDefaults.standard
    
    fileprivate var deviceType: SensorType = .Invalid
    var _isReporting = false
    
    ///Initializer that takes the `FileWriterService` and the `SensorType`
    init(fileWriterService: FileWriterService, deviceType: SensorType) {
        fileWriter = fileWriterService
        self.deviceType = deviceType
    }

    ///Prevent simple initialization
    fileprivate override init(){}
    
    ///Bool that indicates if `DeviceSensor` has been activated
    var isActive: Bool{
        get{
            return defaults.bool(forKey: deviceType.rawValue)
        }
        set{
            defaults.set(newValue, forKey: deviceType.rawValue)
            defaults.synchronize()
        }
    }
    
    ///Bool that indicates if `DeviceSensor` reading has been activated
    var isReporting: Bool{
        
        get{
            return _isReporting
        }
    }
}
