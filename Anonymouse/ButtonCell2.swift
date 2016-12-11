//
//  ButtonCell2.swift
//  Anonymouse
//
//  Created by Dominic Vernazza on 12/10/16.
//  Copyright © 2016 Dominic Vernazza. All rights reserved.
//

import UIKit
protocol ButtonCellDelegate2 {
    func cellTapped2(_ cell: ButtonCell2)
    
}
class ButtonCell2: UITableViewCell {
    
    var buttonDelegate2: ButtonCellDelegate2?
    
    
    @IBAction func buttonTap2(_ sender: AnyObject) {
        if let delegate2 = buttonDelegate2{
            delegate2.cellTapped2(self)
        }
        
        
}
    

    @IBOutlet weak var mineScoreLabel: UILabel!
    
    @IBOutlet weak var mineTextLabel: UITextView!


}
