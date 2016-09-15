//
//  SettingCell.swift
//  SensorApp
//
//  Copyright © 2016 Zühlke Engineering AG. All rights reserved.
//

import UIKit

/**
 This class is the view model for the setting cell. It shows the name of the setting item.
 */
class SettingCell: UITableViewCell {

    static let cellIdentifier = "SettingCell"
    @IBOutlet weak var label: UILabel!
    
    func setDisplayName(_ displayName: String){
        label!.text = displayName
    }
}
