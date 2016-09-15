//
//  UIDeviceExtension.swift
//  SensorApp
//
//  Copyright © 2016 Zühlke Engineering AG. All rights reserved.
//
import AVFoundation
import UIKit
/**
 The purpose of the `UIDevice` extension is to add some missing functions to Apples `UIDevice` class
 */
extension UIDevice  {
    
    ///Check if the app is Running on a simulator
    var isSimulator: Bool {
        
        return TARGET_OS_SIMULATOR != 0
    }
    
    ///Create and persist a DeviceID. This ID is used to identify the device and so the lift where it is installed. The deviceID is stored in NSUserDefaults and wiped if the app gets deleted.
    var deviceID : String{
        
        let key = "DEVICE_ID"
    
        let defaults = NSUserDefaults.standardUserDefaults()
        if  let device  = defaults.stringForKey(key){
            return device
        }else{
            let device = NSUUID().UUIDString
            defaults.setValue(device, forKey: key)
            defaults.synchronize()
            return device
        }
    }

}
