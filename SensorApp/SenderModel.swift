//
//  SenderModel.swift
//  SensorApp
//
//  Copyright © 2016 Zühlke Engineering AG. All rights reserved.
//
import AVFoundation

class SenderModel: NSObject {

    static let sharedInstance = SenderModel()
    fileprivate var senderStore = [DeviceSender]()
    
    
    ///Method to initialize all senders
    func setup(){
        senderStore.append(BeaconSender())
    }
    
    ///method to start all senders at once
    func startAllSenders(){
        
        for sender in senderStore{
            sender.startSending()
        }
    }
    
    ///method to stop all senders at once
    func shutdownSenders(){
        
        for sender in senderStore{
            sender.stopSending()
        }
        senderStore.removeAll()
    }
    
    
    ///method to receive all initialized classes of type `DeviceSender`
    func senders()->[DeviceSender]{
        return senderStore
    }
    
}
