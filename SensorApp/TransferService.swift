//
//  TransferService.swift
//  SensorApp
//
//  Copyright © 2016 Zühlke Engineering AG. All rights reserved.
//
import AVFoundation
import UIKit
/**
 The purpose of the `TransferService` class is to transfer data from the cache to the backend.
 To parallize transfer of the sensor data there are multiple instances of the `TransferService`. One per `DeviceSensor`
 */
class TransferService: NSObject {

    private let fileReaderService = FileReaderService()
    private let urlString = SettingModel.sharedInstance.getSetting(SettingDescriptor.WebApiUrl)!.value
    private let username = SettingModel.sharedInstance.getSetting(SettingDescriptor.Username)!.value
    private let password = SettingModel.sharedInstance.getSetting(SettingDescriptor.Password)!.value
    private var loginString: String?
    private var deviceID = UIDevice.currentDevice().deviceID
    private var deviceType = UIDevice.currentDevice().systemName
    private var sensorType = SensorType.Invalid
    private var transmissionInterval = 5.0
    
    private var base64LoginString: String{
    
        get{
            if let loginString = loginString{
                return loginString
            }
            else{
                let loginData : NSData = NSString(format: "%@:%@", username, password).dataUsingEncoding(NSUTF8StringEncoding)!
                loginString = loginData.base64EncodedStringWithOptions([])
                return loginString!
            }
        }
    }
    
    ///Public initializer as a `Transferservice` only transfers data of a type
    init(sensorType: SensorType){
        self.sensorType = sensorType
    }
    
    ///Tranfer data by requesting the oldest data by `SensorType` and delete the file after a successfull transmission. If the queue runs out of data the method calls itself with a delay
    func transfer(){
        
        let oldestData = fileReaderService.readOldestFileFromDisk(sensorType)
        
        if let jsonData = oldestData.data{
            
            if sensorType == SensorType.DeviceMotion{
                //let theJSONText = NSString(data: jsonData, encoding: NSASCIIStringEncoding)
                //print(theJSONText)
            }
            transferData(jsonData, successHandler: { (success: Bool) in
                if success == true{
                    self.fileReaderService.deleteFileAtPath(oldestData.path)
                }
                self.transfer()
            })
        }
        else{
            callTransferWithDelay()
        }
    }
    
    private func callTransferWithDelay(){
        //repeat 5 seconds after queue is empty - as we are in a background thread things are a bit more complicated
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            let timer = NSTimer.scheduledTimerWithTimeInterval(self.transmissionInterval, target: self, selector: #selector(self.transfer), userInfo: nil, repeats: false)
            NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
            NSRunLoop.currentRunLoop().run()
        });
    }
    
    ///Add deviceID and deviceType as URL parameter so that the backend identifies the sensor device
    private func buildURL()->NSURL?{
    
        let components = NSURLComponents(string: urlString)
        let deviceIDParam = NSURLQueryItem(name: "deviceID", value: deviceID)
        let deviceTypeParam = NSURLQueryItem(name: "deviceType", value: deviceType)
        components?.queryItems = [deviceIDParam, deviceTypeParam]
        
        return components?.URL
    }
    
    ///Create request: Only basic authentication to keep things simple
    private func buildURLRequest() -> NSMutableURLRequest?{
        
        guard let url = buildURL() else {
            print("onvalid url")
            return nil
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.timeoutInterval = 60
        
        return request
    }
    
    ///Transfer data with a success callback handler
    private func transferData(jsonData: NSData, successHandler: Bool -> ()){
        
        guard let request = buildURLRequest() else {
            return
        }
        
        request.HTTPBody = jsonData
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
           
            if error != nil {
                print("Error -> \(error?.localizedDescription)")
                successHandler(false)
                NSNotificationCenter.defaultCenter().postNotificationName("TRANSMISSION_ERROR", object: NSDate())
                return
            }
            
            if let resp = response as? NSHTTPURLResponse{
                if resp.statusCode >= 400{
                    print("Error -> invalid statuscode")
                    successHandler(false)
                    NSNotificationCenter.defaultCenter().postNotificationName("TRANSMISSION_ERROR", object: NSDate())
                    return
                }
            }
            successHandler(true)
            print("data transfered")
        }
        task.resume()
    }
    
    
}
