//
//  BestViewController.swift
//  Anonymouse
//
//  Created by Dominic Vernazza on 12/9/16.
//  Copyright © 2016 Dominic Vernazza. All rights reserved.
//

import UIKit

class BestViewController: UITableViewController, UITabBarControllerDelegate, ButtonCellDelegate {
   let bestPhoneID = UIDevice.current.identifierForVendor!.uuidString
    var scoreArray: [Int] = []
    var textArray: [String] = []
    var phoneIDArray: [String] = []
    var color: Int = 2
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(NewTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView.delegate = self
        self.tabBarController?.delegate = self
        scoreArray.removeAll()
        textArray.removeAll()
        phoneIDArray.removeAll()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
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
        cell.subtitleLabel.alpha = 0
        cell.subtitleLabel.text = phoneIDArray[indexPath.row]
        if (AnonyMouseDB.instance.beenLiked(likedPhoneNumber: cell.subtitleLabel.text!, likedMouse: cell.anonymouseText.text!, yourPhoneNumber: bestPhoneID)) == true {
           cell.upButton.alpha = 0
           
        }
        
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
    
    func reportCellTapped(_ cell: ButtonCell) {
        let cellText = cell.anonymouseText.text
        let cellID = cell.subtitleLabel.text
        self.addReport(cellText: cellText!, cellID: cellID!)
    }
    
    func downCellTapped(_ cell: ButtonCell) {
        let cellText = cell.anonymouseText.text
        let cellID = cell.subtitleLabel.text
        self.downScore(cellText: cellText!, cellID: cellID!)
    }
    

    func addScore(cellText: String, cellID: String) {
        AnonyMouseDB.instance.addScore(cellText: cellText, cellID: cellID)
        AnonyMouseDB.instance.addMyScore(cellText: cellText, cellID: cellID)
        let liked: Liked = Liked(likedText: cellText, likedCellID: cellID, yourCellID: bestPhoneID)
        AnonyMouseDB.instance.addLiked(anonymice: liked)
        color = 1
            update()
            
    }
    
    func addReport(cellText: String, cellID: String) {
        AnonyMouseDB.instance.addReport(cellText: cellText, cellID: cellID)
        
        if (AnonyMouseDB.instance.getReport(cellText: cellText, cellID: cellID)) >= 4 {
            AnonyMouseDB.instance.deleteAnonyMouse(cellText: cellText, cellID: cellID)
            AnonyMouseDB.instance.deleteMyAnonyMouse(cellText: cellText, cellID: cellID)
        }
        
        update()
    }
    
    func downScore(cellText: String, cellID: String) {
        AnonyMouseDB.instance.downScore(cellText: cellText, cellID: cellID)
        AnonyMouseDB.instance.downMyScore(cellText: cellText, cellID: cellID)
        color = 1
        if (AnonyMouseDB.instance.getScore(cellText: cellText, cellID: cellID)) <= -5 {
            AnonyMouseDB.instance.deleteAnonyMouse(cellText: cellText, cellID: cellID)
        }
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
            AnonyMouseDB.instance.deleteDate()
    }
        self.refreshView()
    }
    
    func refreshView() {
        self.viewDidLoad()
        self.viewWillAppear(true)
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        scoreArray.removeAll()
        textArray.removeAll()
        phoneIDArray.removeAll()
        
        let mouseArray: [Mouse] = AnonyMouseDB.instance.getBestAnonyMouse()
        
        for mice in mouseArray {
            
            textArray.append(mice.text)
            scoreArray.append(Int(mice.score))
            phoneIDArray.append(mice.phoneID)
        }
        
        
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    

}


