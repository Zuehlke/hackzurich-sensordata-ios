//
//  AppDelegate.swift
//  SensorApp
//
//  Copyright © 2016 Zühlke Engineering AG. All rights reserved.
//

import UIKit

/**
 The app delegate. All stubs removed as they are not needed.
 */
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    ///The UIWindow of the app
    var window: UIWindow?

    ///When the application lauches all sensors are setup and the data transfer is initialized
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // initializing default settings
        SettingModel.sharedInstance.setup()
        
        //start sensormodel and transfer to server
        SensorModel.sharedInstance.setup()
        SensorModel.sharedInstance.startTransfer()
        
        //start sender model and all senders
        SenderModel.sharedInstance.setup()
        SenderModel.sharedInstance.startAllSenders()


        UIApplication.sharedApplication().idleTimerDisabled = true
        
        return true
    }
}

