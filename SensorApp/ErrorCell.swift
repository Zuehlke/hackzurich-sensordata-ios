//
//  ErrorCell.swift
//  SensorApp
//
//  Copyright © 2016 Zühlke Engineering AG. All rights reserved.
//

import UIKit

/**
 This class is the view model for the error cell. It displays the error sent via NSNotificationCenter.
 */
class ErrorCell: UITableViewCell {

    static let cellIdentifier = "ErrorCell"
    
    @IBOutlet weak var errorLabel: UILabel! 
    fileprivate let dateFormatter = Utils.dateFormatterShort()

    func setDateOfLastError(_ date: Date?){
    
        guard let date = date else{
            errorLabel.text = "no error"
            return
        }
        errorLabel.text = dateFormatter.string(from: date)
    }

}
