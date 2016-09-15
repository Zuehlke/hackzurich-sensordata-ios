//
//  SensorToggleCell.swift
//  SensorApp
//
//  Copyright © 2016 Zühlke Engineering AG. All rights reserved.
//

import UIKit

/**
 This class is the view model for the sensor cell to enable the user to turn sensors on and off
 */
class SensorCell: UITableViewCell {

    static let cellIdentifier = "SensorCell"
    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var label: UILabel!
    fileprivate var sensor: DeviceSensor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    ///Sets the cell's properties
    func initializeSensorCell(_ sensorData: DeviceSensor){
        toggle.isEnabled = sensorData.isAvailable
        label.text = sensorData.type.rawValue
        toggle.isOn = sensorData.isActive
        sensor = sensorData
    }

    ///Action listener when the toggle is tapped. Starts or stops the sensor. 
    @IBAction func toggleSensor(_ sender: UISwitch) {
        if(sender.isOn){
            sensor?.startReporting()
        }
        else{
            sensor?.stopReporting()
        }
        sensor?.isActive = sender.isOn
    }
}
