//
//  BeaconSender.swift
//  SensorApp
//
//  Copyright © 2016 Zühlke Engineering AG. All rights reserved.
//

import CoreBluetooth
import CoreLocation
import UIKit

/**
 The purpose of the `BeaconSender` class is to use the iPhone as an iBeacon
 The `BeaconSender` class conforms to the `DeviceSender` protocol.
 */
class BeaconSender: NSObject, DeviceSender, CBPeripheralManagerDelegate {

    private var localBeacon: CLBeaconRegion!
    private var beaconPeripheralData: NSDictionary!
    private var peripheralManager: CBPeripheralManager!
    
    
    /// A Bool that indicates that beacon ranging is available on the device
    var isAvailable : Bool{
        
        get{
            if UIDevice.currentDevice().isSimulator{
                return false
            }
            if !CLLocationManager.isRangingAvailable(){
                return false
            }
            return true
        }
    }
    
    
    ///Names the type of covered sender
    var type: SenderType {
        get{
            return .Beacon
        }
    }
    
    ///Create a random Major number. And keep it during installation
    var beaconMajor : Int{
        get{
            let key = "BEACON_MAJOR"
            
            let defaults = NSUserDefaults.standardUserDefaults()
            var major  = defaults.integerForKey(key)
            
            if major != 0 {
              return major
            }
            else{
                //create a random number between 100 and 999 and persist it
                major = Int(arc4random_uniform(899) + 100);
                defaults.setValue(major, forKey: key)
                defaults.synchronize()
                return major
            }
        }
    }
    
    ///Create a random Minor number. And keep it during installation
    var beaconMinor : Int{
        get{
            let key = "BEACON_MINOR"
            
            let defaults = NSUserDefaults.standardUserDefaults()
            var minor  = defaults.integerForKey(key)
            
            if minor != 0 {
                return minor
            }
            else{
                //create a random number between 100 and 999 and persist it
                minor = Int(arc4random_uniform(899) + 100);
                defaults.setValue(minor, forKey: key)
                defaults.synchronize()
                return minor
            }
        }
    }

    ///Method to start sending
    func startSending(){
        
        if localBeacon != nil {
            stopSending()
        }
        
        //a typical beaconID
        let localBeaconUUID = "f7826da6-4fa2-4e98-8024-bc5b71e0893e"
        let localBeaconMajor: CLBeaconMajorValue = UInt16(beaconMajor)
        let localBeaconMinor: CLBeaconMinorValue = UInt16(beaconMinor)
        
        let uuid = NSUUID(UUIDString: localBeaconUUID)!
        localBeacon = CLBeaconRegion(proximityUUID: uuid, major: localBeaconMajor, minor: localBeaconMinor, identifier: "iPhone Beacon")
        
        beaconPeripheralData = localBeacon.peripheralDataWithMeasuredPower(NSNumber(int: 1))
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    
    ///Method to stop sending
    func stopSending(){
        peripheralManager.stopAdvertising()
        peripheralManager = nil
        beaconPeripheralData = nil
        localBeacon = nil
    }


    ///CBPeripheralManagerDelegate method: start and stop advertising based on state
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
       
        if peripheral.state == .PoweredOn {
            peripheralManager.startAdvertising(beaconPeripheralData as! [String: AnyObject]!)
        } else if peripheral.state == .PoweredOff {
            peripheralManager.stopAdvertising()
        }
    }
    
    
    ///CBPeripheralManagerDelegate method: printing feedback of advertising
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?) {
        
        if let error = error{
            print("Error with beaconSender: \(error.localizedDescription)")
        }else {
            print("Device acts as a beacon now: \nUUID:\(localBeacon.proximityUUID.UUIDString)\nMajor: \(localBeacon.major!)\nMinor:\(localBeacon.minor!)")
        }
    }
    
    
}



