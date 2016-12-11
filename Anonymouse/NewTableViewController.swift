//
//  NewTableViewController.swift
//  Anonymouse
//
//  Created by Dominic Vernazza on 11/28/16.
//  Copyright © 2016 Dominic Vernazza. All rights reserved.
//

import UIKit

class NewTableViewController: UITableViewController, ButtonCellDelegate3 {
    var scoreArray: [Int] = []
    var textArray: [String] = []
    var color: Int = 2
    var phoneIDArray: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let mouseArray: [Mouse] = AnonyMouseDB.instance.getAnonyMouse()
        
        for mice in mouseArray {
            
            textArray.append(mice.text)
            scoreArray.append(Int(mice.score))
            phoneIDArray.append(mice.phoneID)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return textArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell3
        
        cell.newMouseText.text = (textArray[indexPath.row])
        if color % 2 == 0 {
            cell.backgroundColor = UIColor.lightGray
            cell.newMouseText.backgroundColor = UIColor.lightGray
        }
        else {
            cell.backgroundColor = UIColor.white
            cell.newMouseText.backgroundColor = UIColor.white
        }
        color += 1
        cell.scoreLabel.text = (String(scoreArray[indexPath.row]))
        cell.subTitleLabel.alpha = 0
        cell.subTitleLabel.text = phoneIDArray[indexPath.row]
        cell.layer.borderColor = UIColor.black.cgColor
        cell.newMouseText.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 8
        cell.newMouseText.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.newMouseText.clipsToBounds = true
        tableView.backgroundColor = UIColor.black
        if cell.buttonDelegate3 == nil {
            cell.buttonDelegate3 = self
        }
        return cell
    }
    
    func cellTapped3(_ cell: ButtonCell3) {
        let cellText = cell.newMouseText.text
        let cellID = cell.subTitleLabel.text
        self.addScore(cellText: cellText!, cellID: cellID!)
    }
    
    
    func addScore(cellText: String, cellID: String) {
        AnonyMouseDB.instance.addScore(cellText: cellText, cellID: cellID)
        color = 1
        update()
        
    }
    
    
    func update () {
        textArray.removeAll()
        scoreArray.removeAll()
        let mouseArray: [Mouse] = AnonyMouseDB.instance.getAnonyMouse()
        for mice in mouseArray {
            textArray.append(mice.text)
            scoreArray.append(Int(mice.score))
            color = 1
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    

}
