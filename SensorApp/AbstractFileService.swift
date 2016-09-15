//
//  AbstractFileService.swift
//  SensorApp
//
//  Copyright © 2016 Zühlke Engineering AG. All rights reserved.
//
import AVFoundation
/**
 The purpose of the `AbstractFileService` class is to share code beetween `FileReaderService` and `FileWriterService`
 */
class AbstractFileService {
    
    fileprivate let fileManager = FileManager.default
    
    ///Folder where the app stores the sensor data as JSON
    internal func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths.first! as NSString
    }
    
    ///Delete file with a given path
    func deleteFileAtPath(_ path: String?){
        
        guard let path = path else {return}
        
        do {
            try fileManager.removeItem(atPath: path)
            
        } catch {
            print("error deleting file \(path) \(error)")
        }
    }
    
}
