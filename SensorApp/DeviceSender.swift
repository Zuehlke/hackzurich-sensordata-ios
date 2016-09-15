//
//  DeviceSender.swift
//  SensorApp
//
//  Copyright © 2016 Zühlke Engineering AG. All rights reserved.
//

///Enum that defines the different types of sensors that are handled by this project
enum SenderType: String{
    /// see `Beacon`
    case Beacon
    /// To handle not set `SensorType`
    case Invalid
}

///Protocol that helps working with classes that use the device sender
protocol DeviceSender {
    
    ///Indicates if a sender is available
    var isAvailable: Bool{get}
    
    ///Names the type of covered sender
    var type: SenderType {get}
    
    ///Method to start sending
    func startSending()
    
    ///Method to stop sending
    func stopSending()
}
