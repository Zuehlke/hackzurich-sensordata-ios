//
//  SettingItem.swift
//  SensorApp
//
//  Copyright © 2016 Zühlke Engineering AG. All rights reserved.
//

import Foundation

/**
 For each setting there is a appropriate setting descriptor to allow mapping and that serves as key to store.
*/
enum SettingDescriptor: String{
    case Username
    case Password
    case WebApiUrl
}

/**
 Represents an individual setting entry.
 */
class SettingItem{
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var isEnabled: Bool
    var displayName: String
    var descriptor: SettingDescriptor
    var defaultValue: String
    
    init(isEnabled: Bool, displayName: String, descriptor: SettingDescriptor, defaultValue: String){
        self.isEnabled = isEnabled
        self.displayName = displayName
        self.descriptor = descriptor
        self.defaultValue = defaultValue
    }
    
    ///Retrieves the value of the setting as String. If there is none, the default value is returned.
    var value: String {
        get {
            return defaults.stringForKey(descriptor.rawValue) ?? defaultValue
        }
        set {
            defaults.setObject(newValue, forKey: descriptor.rawValue)
            defaults.synchronize()
        }
    }
    
    
}