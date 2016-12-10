//
//  ButtonCell.swift
//  Anonymouse
//
//  Created by Dominic Vernazza on 12/9/16.
//  Copyright © 2016 Dominic Vernazza. All rights reserved.
//

import UIKit
protocol ButtonCellDelegate {
    func cellTapped(_ cell: ButtonCell)

}
class ButtonCell: UITableViewCell {

    var buttonDelegate: ButtonCellDelegate?


    @IBAction func buttonTap(_ sender: AnyObject) {
        if let delegate = buttonDelegate {
            delegate.cellTapped(self)
        }


    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
   

}
