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
    
    private let fileManager = NSFileManager.defaultManager()
    
    ///Folder where the app stores the sensor data as JSON
    internal func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths.first!
    }
    
    ///Delete file with a given path
    func deleteFileAtPath(path: String?){
        
        guard let path = path else {return}
        
        do {
            try fileManager.removeItemAtPath(path)
            
        } catch {
            print("error deleting file \(path) \(error)")
        }
    }
    
}
