//
//  SensorTogglesViewController.swift
//  SensorApp
//
//  Copyright © 2016 Zühlke Engineering AG. All rights reserved.
//

import UIKit

/**
 This is the main view controller of the app which manages the settings view
 */
class SensorTogglesViewController: UIViewController {
    @IBOutlet weak var settingsTable: UITableView!
    

    private var settings = [SettingItem]()
    private var deviceSensors = [DeviceSensor]()
    private var dateOfLastError : NSDate?
   
    ///Gets called when view is ready to be displayed
    override func viewDidLoad() {
        super.viewDidLoad()

        settings = SettingModel.sharedInstance.settings()
        deviceSensors = SensorModel.sharedInstance.sensors()
        
        settingsTable.dataSource = self
        settingsTable.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showTransmissionError(_:)), name: "TRANSMISSION_ERROR", object: nil)
    }
    
    ///Is been called by NSNotificationCenter
    func showTransmissionError(notification: NSNotification){
    
        dispatch_async(dispatch_get_main_queue(),{
        
            if let date = notification.object as? NSDate{
                self.dateOfLastError = date
            }
            self.settingsTable.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)
        })
    }
    
    ///Gets a setting cell for the specified row
    func resolveSettingsCell(tableView: UITableView, indexPath: NSIndexPath) -> SettingCell{
        ///If the row number exceeds the number of settings an empty setting cell is returned
        guard indexPath.row < settings.count else {
            return SettingCell()
        }
            
        let settingItem = settings[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(SettingCell.cellIdentifier, forIndexPath: indexPath) as? SettingCell{
            cell.setDisplayName(settingItem.displayName)
            
            return cell;
        }
        
        return SettingCell()
    }
    
    ///Gets a sensor (toggle) cell for the specified row
    func resolveSensorCell(tableView: UITableView, indexPath: NSIndexPath) -> SensorCell{
        ///If the row number exceeds the number of settings an empty sensor cell is returned
        guard indexPath.row < deviceSensors.count else {
            return SensorCell()
        }
        
        let sensor = deviceSensors[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(SensorCell.cellIdentifier, forIndexPath: indexPath) as? SensorCell{
            cell.initializeSensorCell(sensor)
            
            return cell
        }
        
        return SensorCell()
    }
    
    ///Gets an error cell for the specified row
    func resolveErrorCell(tableView: UITableView, indexPath: NSIndexPath) -> ErrorCell{
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(ErrorCell.cellIdentifier, forIndexPath: indexPath) as? ErrorCell{
            cell.setDateOfLastError(dateOfLastError)
            
            return cell
        }
        
        return ErrorCell()
    }
    
}

///Extension to satisfy the protocoll
extension SensorTogglesViewController: UITableViewDataSource {
    
    ///Table view consists 3 section
    func numberOfSectionsInTableView (tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return deviceSensors.count
        case 1:
            return settings.count
        case 2:
            return 1
            
        default:
            return 0
        }
    }
    
    ///Returns the right table cell according to the section
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell{
            
            let section = indexPath.section
            
            if section == 0{
                return resolveSensorCell(tableView, indexPath: indexPath)
            }
            if section == 1{
                return resolveSettingsCell(tableView, indexPath: indexPath)
            }
            else{
                return resolveErrorCell(tableView, indexPath: indexPath)
            }
    }
}

///Extension to satisfy the protocoll
extension SensorTogglesViewController: UITableViewDelegate{
    ///Delegate that is called when a table cell in setting section is tapped. Displays a pop-up with a text input when tapped
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.section == 1 else {
            return
        }
        
        let settingItem = settings[indexPath.row]
        
        let alert = UIAlertController(title: settingItem.displayName,
                                      message: "Set a value for \(settingItem.displayName)",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        ///Handles to save the new setting value when user taps on save
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) {(action: UIAlertAction) in
            if let textfield = alert.textFields![0] as UITextField?{
                settingItem.value = textfield.text!
            }
        }
        
        ///Makes no action when user taps on cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) in
            textField.text = settingItem.value
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    ///Gets the name of the specified section
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Sensors"
        case 1:
            return "Common settings"
        case 2:
            return "Error console"
        default:
            return ""
        }
    }
}