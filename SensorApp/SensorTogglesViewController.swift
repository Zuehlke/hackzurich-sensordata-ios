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
    

    fileprivate var settings = [SettingItem]()
    fileprivate var deviceSensors = [DeviceSensor]()
    fileprivate var dateOfLastError : Date?
   
    ///Gets called when view is ready to be displayed
    override func viewDidLoad() {
        super.viewDidLoad()

        settings = SettingModel.sharedInstance.settings()
        deviceSensors = SensorModel.sharedInstance.sensors()
        
        settingsTable.dataSource = self
        settingsTable.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(showTransmissionError(_:)), name: NSNotification.Name(rawValue: "TRANSMISSION_ERROR"), object: nil)
    }
    
    ///Is been called by NSNotificationCenter
    func showTransmissionError(_ notification: Notification){
    
        DispatchQueue.main.async(execute: {
        
            if let date = notification.object as? Date{
                self.dateOfLastError = date
            }
            self.settingsTable.reloadSections(IndexSet(integer: 2), with: .none)
        })
    }
    
    ///Gets a setting cell for the specified row
    func resolveSettingsCell(_ tableView: UITableView, indexPath: IndexPath) -> SettingCell{
        ///If the row number exceeds the number of settings an empty setting cell is returned
        guard (indexPath as NSIndexPath).row < settings.count else {
            return SettingCell()
        }
            
        let settingItem = settings[(indexPath as NSIndexPath).row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.cellIdentifier, for: indexPath) as? SettingCell{
            cell.setDisplayName(settingItem.displayName)
            
            return cell;
        }
        
        return SettingCell()
    }
    
    ///Gets a sensor (toggle) cell for the specified row
    func resolveSensorCell(_ tableView: UITableView, indexPath: IndexPath) -> SensorCell{
        ///If the row number exceeds the number of settings an empty sensor cell is returned
        guard (indexPath as NSIndexPath).row < deviceSensors.count else {
            return SensorCell()
        }
        
        let sensor = deviceSensors[(indexPath as NSIndexPath).row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: SensorCell.cellIdentifier, for: indexPath) as? SensorCell{
            cell.initializeSensorCell(sensor)
            
            return cell
        }
        
        return SensorCell()
    }
    
    ///Gets an error cell for the specified row
    func resolveErrorCell(_ tableView: UITableView, indexPath: IndexPath) -> ErrorCell{
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: ErrorCell.cellIdentifier, for: indexPath) as? ErrorCell{
            cell.setDateOfLastError(dateOfLastError)
            
            return cell
        }
        
        return ErrorCell()
    }
    
}

///Extension to satisfy the protocoll
extension SensorTogglesViewController: UITableViewDataSource {
    
    ///Table view consists 3 section
    func numberOfSections (in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell{
            
            let section = (indexPath as NSIndexPath).section
            
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard (indexPath as NSIndexPath).section == 1 else {
            return
        }
        
        let settingItem = settings[(indexPath as NSIndexPath).row]
        
        let alert = UIAlertController(title: settingItem.displayName,
                                      message: "Set a value for \(settingItem.displayName)",
                                      preferredStyle: UIAlertControllerStyle.alert)
        ///Handles to save the new setting value when user taps on save
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default) {(action: UIAlertAction) in
            if let textfield = alert.textFields![0] as UITextField?{
                settingItem.value = textfield.text!
            }
        }
        
        ///Makes no action when user taps on cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { (textField: UITextField) in
            textField.text = settingItem.value
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    ///Gets the name of the specified section
    private func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
