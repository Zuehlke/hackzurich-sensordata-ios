//
//  SettingModel.swift
//  SensorApp
//
//  Copyright © 2016 Zühlke Engineering AG. All rights reserved.
//

import Foundation

/**
 This class initializes and keeps the setting objects.
 */
class SettingModel: NSObject{
    static let sharedInstance = SettingModel()
    private var settingStore = [SettingItem]()
    
    func setup(){
        settingStore.append(SettingItem(isEnabled: true, displayName: "User name", descriptor: .Username, defaultValue: "hackzurich"))
        settingStore.append(SettingItem(isEnabled: true, displayName: "Password", descriptor: .Password, defaultValue: "hackzurich"))
        settingStore.append(SettingItem(isEnabled: true, displayName: "Web API URL", descriptor: .WebApiUrl, defaultValue: "http://maininges-publicsl-134cgkz5px771-1262770141.us-west-1.elb.amazonaws.com/sensorReading/"))
    }
    
    ///Returns all setting items
    func settings()->[SettingItem]{
        return settingStore
    }
    
    ///Retrieves a setting item via the setting descriptor. Returns nil of setting item could not be found
    func getSetting(descriptor: SettingDescriptor) -> SettingItem? {
        if let index = settingStore.indexOf({$0.descriptor == descriptor}){
            return settingStore[index]
        }
        
        return nil
    }
    
}