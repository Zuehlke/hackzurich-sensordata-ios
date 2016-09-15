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

    fileprivate let fileReaderService = FileReaderService()
    fileprivate let urlString = SettingModel.sharedInstance.getSetting(SettingDescriptor.WebApiUrl)!.value
    fileprivate let username = SettingModel.sharedInstance.getSetting(SettingDescriptor.Username)!.value
    fileprivate let password = SettingModel.sharedInstance.getSetting(SettingDescriptor.Password)!.value
    fileprivate var loginString: String?
    fileprivate var deviceID = UIDevice.current.deviceID
    fileprivate var deviceType = UIDevice.current.systemName
    fileprivate var sensorType = SensorType.Invalid
    fileprivate var transmissionInterval = 5.0
    
    fileprivate var base64LoginString: String{
    
        get{
            if let loginString = loginString{
                return loginString
            }
            else{
                let loginData : Data = NSString(format: "%@:%@", username, password).data(using: String.Encoding.utf8.rawValue)!
                loginString = loginData.base64EncodedString(options: [])
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
    
    fileprivate func callTransferWithDelay(){
        //repeat 5 seconds after queue is empty - as we are in a background thread things are a bit more complicated
        DispatchQueue.global(qos: .background).async {
            let timer = Timer.scheduledTimer(timeInterval: self.transmissionInterval, target: self, selector: #selector(self.transfer), userInfo: nil, repeats: false)
            RunLoop.current.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
            RunLoop.current.run()
        }
    }
    
    ///Add deviceID and deviceType as URL parameter so that the backend identifies the sensor device
    fileprivate func buildURL()->URL?{
    
        var components = URLComponents(string: urlString)
        let deviceIDParam = URLQueryItem(name: "deviceID", value: deviceID)
        let deviceTypeParam = URLQueryItem(name: "deviceType", value: deviceType)
        components?.queryItems = [deviceIDParam, deviceTypeParam]
        
        return components?.url
    }
    
    ///Create request: Only basic authentication to keep things simple
    fileprivate func buildURLRequest() -> URLRequest?{
        
        guard let url = buildURL() else {
            print("onvalid url")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.timeoutInterval = 60
        
        return request
    }
    
    ///Transfer data with a success callback handler
    fileprivate func transferData(_ jsonData: Data, successHandler: @escaping (Bool) -> ()){
        
        guard var request = buildURLRequest() else {
            return
        }
        
        request.httpBody = jsonData
        
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
           
            if error != nil {
                print("Error -> \(error?.localizedDescription)")
                successHandler(false)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "TRANSMISSION_ERROR"), object: Date())
                return
            }
            
            if let resp = response as? HTTPURLResponse{
                if resp.statusCode >= 400{
                    print("Error -> invalid statuscode")
                    successHandler(false)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "TRANSMISSION_ERROR"), object: Date())
                    return
                }
            }
            successHandler(true)
            print("data transfered")
        })
        task.resume()
    }
    
    
}
