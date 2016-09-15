//
//  DeviceSensor.swift
//  SensorApp
//
//  Copyright © 2016 Zühlke Engineering AG. All rights reserved.
//


///Enum that defines the different types of sensors that are handled by this project
enum SensorType: String{
    /// see `BarometerSensor`
    case Barometer
    /// see `AccelerometerSensor`
    case Accelerometer
    /// see `GyroSensor`
    case Gyrometer
    /// see `DeviceMotionSensor`
    case DeviceMotion
    /// see `MagnetometerSensor`
    case Magnetometer
    /// see `BatteryLevelSensor`
    case BatteryLevel
    /// see `MicrophoneSensor`
    case Microphone
    /// see `LightSensor`
    case Light
    /// see `Beacon`
    case Beacon
    /// To handle not set `SensorType`
    case Invalid
}

///Protocol that helps working with classes that read the device sensors
protocol DeviceSensor {
    
    ///Indicates if a sensor is available
    var isAvailable: Bool{get}
    
    ///Names the type of covered sensor
    var type: SensorType {get}
    
    ///Indicates if the sensor has been activated by the user
    var isActive: Bool {get set}
    
    ///Indicates if the sensor data is read
    var isReporting: Bool {get}
    
    ///Method to start the sensor reading
    func startReporting()
    
    ///Method to stop the sensor reading
    func stopReporting()
}