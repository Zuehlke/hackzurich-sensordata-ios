//
//  DeviceMotionSensor.swift
//  SensorApp
//
//  Copyright © 2016 Zühlke Engineering AG. All rights reserved.
//

import CoreMotion

/**
 The purpose of the `DeviceMotionSensor` class is to provide the data that is generated by the devicemotion sensor of the device.
 For details of this sensor see http://nshipster.com/cmdevicemotion/
 
 The `DeviceMotionSensor` class is a subclass of the `AbstractSensor`, and it conforms to the `DeviceSensor` protocol.
 */
class DeviceMotionSensor: AbstractSensor, DeviceSensor {

    private weak var manager : CMMotionManager?

    
    /// A Bool that indicates that the motion sensor is available on the device
    var isAvailable : Bool{
        
        get{
            guard let manager = manager else {return false}
            return manager.magnetometerAvailable
        }
    }
    
    /// The type of class is DeviceMotion
    var type : SensorType {
        get{
            return .DeviceMotion
        }
    }
    
    /**
     Public initializer that takes `CMMotionManager` and `FileWriterService` as an argument.
     `CMMotionManager` must be injected because Apple recommends to have only one instance of it for performance reasons as it is used in multiple sensor classes.
     `FileWriterService` is used to save the measured results.
     */
    init(motionManager: CMMotionManager, fileWriterService: FileWriterService) {
        super.init(fileWriterService: fileWriterService, deviceType: .DeviceMotion)
        manager = motionManager
    }

    /**
     Method to start the reporting of sensor data. The data is read with the interval specified by `accelerometerUpdateInterval`
     */
    func startReporting(){
        
        guard isAvailable else {
            print("DeviceMotionSensor not available")
            return
        }
        guard let manager = manager else {return }
        
        _isReporting = true
        
        manager.deviceMotionUpdateInterval = 0.1
        manager.startDeviceMotionUpdatesToQueue(NSOperationQueue()) {
            (data: CMDeviceMotion?, error: NSError?) in
            
            self.persistData(data)
        }
    }
    
    
    ///method that writes the data from the sensor into a dictionary structur for later JSON generation
    private func persistData(data: CMDeviceMotion?){
        
        guard let data = data else {return}
        
        var params = [String:AnyObject]()
        params["type"] = "DeviceMotion"
        params["date"] = dateFormatter.stringFromDate(NSDate())
        
        var attitude = [String:AnyObject]()
        attitude["pitch"] = data.attitude.pitch
        attitude["yaw"] = data.attitude.yaw
        attitude["roll"] = data.attitude.roll
        
        var quaternion = [String:AnyObject]()
        quaternion["w"] = data.attitude.quaternion.w
        quaternion["x"] = data.attitude.quaternion.x
        quaternion["y"] = data.attitude.quaternion.y
        quaternion["z"] = data.attitude.quaternion.z
        attitude["quaternion"] = quaternion
        
        var rotationRate = [String:AnyObject]()
        rotationRate["x"] = data.rotationRate.x
        rotationRate["y"] = data.rotationRate.y
        rotationRate["z"] = data.rotationRate.z
        attitude["rotationRate"] = rotationRate
        
        var rotationMatrix = [String:AnyObject]()
        rotationMatrix["m11"] = data.attitude.rotationMatrix.m11
        rotationMatrix["m12"] = data.attitude.rotationMatrix.m12
        rotationMatrix["m13"] = data.attitude.rotationMatrix.m13
        rotationMatrix["m21"] = data.attitude.rotationMatrix.m21
        rotationMatrix["m22"] = data.attitude.rotationMatrix.m22
        rotationMatrix["m23"] = data.attitude.rotationMatrix.m23
        rotationMatrix["m31"] = data.attitude.rotationMatrix.m31
        rotationMatrix["m32"] = data.attitude.rotationMatrix.m32
        rotationMatrix["m33"] = data.attitude.rotationMatrix.m33
        attitude["rotationMatrix"] = rotationMatrix
        
        params["attitude"] = attitude
        
        fileWriter?.addLine(params)
    }
    
    ///method that stops sensor reading and generation of data
    func stopReporting(){
        guard let manager = manager else {return }
        manager.stopDeviceMotionUpdates()
        _isReporting = false
    }

    
}
