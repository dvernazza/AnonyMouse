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
    func reportCellTapped(_ cell: ButtonCell)
    func downCellTapped(_ cell: ButtonCell)
}
class ButtonCell: UITableViewCell {

    var buttonDelegate: ButtonCellDelegate?

    @IBOutlet weak var upButton: UIButton!
    
    @IBOutlet weak var downButton: UIButton!
    
    @IBAction func reportButtonTap(_ sender: AnyObject) {
        if let delegate = buttonDelegate {
            delegate.reportCellTapped(self)
        }
    }

    @IBAction func buttonTap(_ sender: AnyObject) {
        if let delegate = buttonDelegate {
            delegate.cellTapped(self)
        }

        

    }

    @IBAction func downButtonTap(_ sender: AnyObject) {
        if let delegate = buttonDelegate {
            delegate.downCellTapped(self)
        }
    }
    @IBOutlet weak var subtitleLabel: UILabel!


    @IBOutlet weak var anonymouseText: UITextView!

    @IBOutlet weak var scoreLabel: UILabel!


}
