//
//  FileReaderService.swift
//  SensorApp
//
//  Copyright © 2016 Zühlke Engineering AG. All rights reserved.
//
import AVFoundation
/**
 The purpose of the `FileReaderService` class is to provide the oldest file per `SensorType` so that it can be transfered to the backend */
class FileReaderService: AbstractFileService {

    
    ///Load oldest file by `SensorType` and return its data and its path as a tuple
    func readOldestFileFromDisk(_ sensorType: SensorType)-> (data: Data?, path: String?){
    
        if let path = pathOfOldestFileOnDisk(sensorType){
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return (jsonData,path)
            } catch {
                print("error reading file \(path) \(error)")
            } 
        }
        return (nil,nil)
    }
    
    
    ///Find oldest file by `SensorType` and return its path
    fileprivate func pathOfOldestFileOnDisk(_ sensorType: SensorType)->String?{
    
        if let url = URL(string: getDocumentsDirectory() as String){
            
            ///All visibible files in documents directory
            if let urlArray = try? FileManager.default.contentsOfDirectory(at: url,
                                                                                           includingPropertiesForKeys: [URLResourceKey.contentModificationDateKey], options:.skipsHiddenFiles) {
                ///Filter path extension by `SensorType` and sort by modification date
                let result = urlArray.filter{ $0.pathExtension == sensorType.rawValue}
                    .map{ url -> (String, TimeInterval) in
                    var lastModified : AnyObject?
                    _ = try? (url as NSURL).getResourceValue(&lastModified, forKey: URLResourceKey.contentModificationDateKey)
                    return (url.relativePath, lastModified?.timeIntervalSinceReferenceDate ?? 0)
                    }
                    .sorted(by: { $0.1 > $1.1 }) // sort descending modification dates
                    .map { $0.0 } // extract file names
                
                print("\(result.count) files on disk of type \(sensorType.rawValue)")

                if let path = result.first{
                    return path
                }
            } else {
                return nil
            }
        }
        return nil
    }
    
}
