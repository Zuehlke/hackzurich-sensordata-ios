//
//  FileWriterService.swift
//  SensorApp
//
//  Copyright © 2016 Zühlke Engineering AG. All rights reserved.
//
import AVFoundation

/**
 The purpose of the `FileWriterService` class is to provide a queue for the 'DeviceSensor' where the results are written to disk if it reaches a certain queue size. So the device can collect sensor data even if the device should be offline
 */
class FileWriterService: AbstractFileService {
    
    private var queue = [[String:AnyObject]]()
    private var sensorType = SensorType.Invalid
    private var fixedCacheSize = -1

    ///Adds data to the queue. Parameter is a dictionary wich was build by the 'DeviceSensor'
    func addLine(params: [String:AnyObject]){
        queue.append(params)
        
        if queue.count > cacheSize{
            writeFileToDisk()
        }
    }
    
    ///Sensor specific cachesize as some sensors generate more data than others
    private var cacheSize:Int{
    
        if fixedCacheSize > -1{
            return fixedCacheSize
        }
        
        switch sensorType {
        case .BatteryLevel:
            fixedCacheSize = 1
        case .DeviceMotion, .Light:
            return 25
        default:
            fixedCacheSize = 100
        }
        return fixedCacheSize
    }
    
    ///Public initializer that takes the `SensorType` as a parameter.
    init(sensorType: SensorType){
        
        self.sensorType = sensorType
        super.init()
    }
    
    ///Hide basic initializer
    private override init(){}
    
    //creating the JSON file and use a filename based on current date and `SensorType`
    private func writeFileToDisk(){
    
        guard queue.count > 0 else { return }
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(queue, options: NSJSONWritingOptions.PrettyPrinted)
        
        //filename is current date as timeinterval plus sensor type name

        let filename = "\(NSDate().timeIntervalSince1970).\(sensorType.rawValue)"
        let pathName = super.getDocumentsDirectory().stringByAppendingPathComponent(filename)
        
        do {
            try jsonData.writeToFile(pathName, options:  NSDataWritingOptions.DataWritingAtomic)
        } catch {
            print("error writing file \(pathName)")
        }
        queue.removeAll()
    }
    
    
    
}
