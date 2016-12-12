//
//  ButtonCell3.swift
//  Anonymouse
//
//  Created by Dominic Vernazza on 12/10/16.
//  Copyright © 2016 Dominic Vernazza. All rights reserved.
//

import UIKit
protocol ButtonCellDelegate3 {
    func cellTapped3(_ cell: ButtonCell3)
    func reportCellTapped3(_ cell: ButtonCell3)
    func downCellTapped3(_ cell: ButtonCell3)
    
}
class ButtonCell3: UITableViewCell {
    
    var buttonDelegate3: ButtonCellDelegate3?
    
    
    @IBAction func buttonTap3(_ sender: AnyObject) {
        if let delegate3 = buttonDelegate3 {
            delegate3.cellTapped3(self)
        }
        
        
    }

    @IBAction func reportButtonTap3(_ sender: AnyObject) {
        if let delegate3 = buttonDelegate3 {
            delegate3.reportCellTapped3(self)
        }
    }
    
    @IBAction func downButtonTap(_ sender: AnyObject) {
        if let delegate3 = buttonDelegate3 {
            delegate3.downCellTapped3(self)
        }
    }

    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var newDownButton: UIButton!
    @IBOutlet weak var newUpButton: UIButton!
    @IBOutlet weak var datedPostedOn: UILabel!
    @IBOutlet weak var newMouseText: UITextView!
    @IBOutlet weak var subTitleLabel: UILabel!
}
