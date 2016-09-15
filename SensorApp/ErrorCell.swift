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
    private let dateFormatter = Utils.dateFormatterShort()

    func setDateOfLastError(date: NSDate?){
    
        guard let date = date else{
            errorLabel.text = "no error"
            return
        }
        errorLabel.text = dateFormatter.stringFromDate(date)
    }

}
