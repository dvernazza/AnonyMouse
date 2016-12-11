//
//  BestViewController.swift
//  Anonymouse
//
//  Created by Dominic Vernazza on 12/9/16.
//  Copyright © 2016 Dominic Vernazza. All rights reserved.
//

import UIKit

class BestViewController: UITableViewController, ButtonCellDelegate {
   var scoreArray: [Int] = []
    var textArray: [String] = []
    var phoneIDArray: [String] = []
    var color: Int = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        let mouseArray: [Mouse] = AnonyMouseDB.instance.getBestAnonyMouse()

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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
        cell.anonymouseText.text = (textArray[indexPath.row])
        if color % 2 == 0 {
        cell.backgroundColor = UIColor.lightGray
        cell.anonymouseText.backgroundColor = UIColor.lightGray
        }
        else {
            cell.backgroundColor = UIColor.white
            cell.anonymouseText.backgroundColor = UIColor.white
        }
        color += 1
        cell.scoreLabel.text = (String(scoreArray[indexPath.row]))
   //     cell.textLabel.numberOfLines = 0
        cell.subtitleLabel.alpha = 0
        cell.subtitleLabel.text = phoneIDArray[indexPath.row]
        cell.layer.borderColor = UIColor.black.cgColor
        cell.anonymouseText.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 8
        cell.anonymouseText.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.anonymouseText.clipsToBounds = true
        tableView.backgroundColor = UIColor.black
        
        if cell.buttonDelegate == nil {
            cell.buttonDelegate = self
        }
        return cell
    }
    func cellTapped(_ cell: ButtonCell) {
        let cellText = cell.anonymouseText.text
        let cellID = cell.subtitleLabel.text
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
        let mouseArray: [Mouse] = AnonyMouseDB.instance.getBestAnonyMouse()
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



