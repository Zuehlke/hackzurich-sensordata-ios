//
//  SensorModel.swift
//  SensorApp
//
//  Copyright © 2016 Zühlke Engineering AG. All rights reserved.
//
import CoreMotion

/**
 The purpose of the `SensorModel` class is to initialize all sensors and provide them to the application
 */
class SensorModel: NSObject {

    static let sharedInstance = SensorModel()
    private var sensorStore = [DeviceSensor]()
    private var transferServices = [TransferService]()
    private let motionManager = CMMotionManager()
    private override init() {}
    
    ///Method to Initialize all sensors
    func setup(){
        sensorStore.append(AccelerometerSensor(motionManager: motionManager, fileWriterService: FileWriterService(sensorType: SensorType.Accelerometer)))
        sensorStore.append(GyroSensor(motionManager: motionManager, fileWriterService: FileWriterService(sensorType: SensorType.Gyrometer)))
        sensorStore.append(MagnetometerSensor(motionManager: motionManager, fileWriterService: FileWriterService(sensorType: SensorType.Magnetometer)))
        sensorStore.append(DeviceMotionSensor(motionManager: motionManager, fileWriterService: FileWriterService(sensorType: SensorType.DeviceMotion)))
        sensorStore.append(BarometerSensor(fileWriterService: FileWriterService(sensorType: SensorType.Barometer)))
        sensorStore.append(BatteryLevelSensor(fileWriterService: FileWriterService(sensorType: SensorType.BatteryLevel)))
        sensorStore.append(MicrophoneSensor(fileWriterService: FileWriterService(sensorType: SensorType.Microphone)))
        sensorStore.append(LightSensor(fileWriterService: FileWriterService(sensorType: SensorType.Light)))
        sensorStore.append(BeaconSensor(fileWriterService: FileWriterService(sensorType:SensorType.Beacon)))
        
        restoreRunningState()
    }
    
    private func restoreRunningState(){
    
        for sensor in sensorStore{
            if sensor.isActive && !sensor.isReporting{
                sensor.startReporting()
            }
        }
    }
    
    ///method to start all sensors at once
    func startAllSensors(){
        
        for sensor in sensorStore{
            sensor.startReporting()
        }
    }
    
    ///method to stop all sensors at once
    func shutdownSensors(){
        
        for sensor in sensorStore{
            sensor.stopReporting()
        }
        sensorStore.removeAll()
    }
    
    
    ///method to receive all initialized classes of type `DeviceSensor`
    func sensors()->[DeviceSensor]{
        return sensorStore
    }
    
    
    //method to start the `TransferService` which transfers all read data to the backend 
    func startTransfer(){
        
        transferServices.removeAll()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            
            for sensor in self.sensorStore{
                let transferService = TransferService(sensorType: sensor.type)
                self.transferServices.append(transferService)
                transferService.transfer()
            }
        })
    } 
}
