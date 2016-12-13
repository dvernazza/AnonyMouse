//
//  MineViewController.swift
//  Anonymouse
//
//  Created by Dominic Vernazza on 12/9/16.
//  Copyright © 2016 Dominic Vernazza. All rights reserved.
//
import MapKit
import UIKit

class MineViewController: UITableViewController, UITabBarControllerDelegate, ButtonCellDelegate2 {
    let myPhoneID = UIDevice.current.identifierForVendor!.uuidString
    var textArray: [String] = []
    var scoreArray: [Int] = []
    var dateArray: [Date] = []
    var color: Int = 2
    var totalScore: Int64 = 0
    var firstLabel: UILabel!
    var labelScore: Int = 0
    @IBOutlet weak var mousePicture: UIImageView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(NewTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        self.tabBarController?.delegate = self
        scoreArray.removeAll()
        textArray.removeAll()
        self.tableView.delegate = self
        let mouseArray: [Mouse] = AnonyMouseDB.instance.getMyMice(myMice: myPhoneID)
        for mice in mouseArray {
            totalScore = totalScore + mice.score
            textArray.append(mice.text)
            scoreArray.append(Int(mice.score))
            var today = mice.date
            today = Calendar.current.date(byAdding: .day, value: -3, to: today)!
            dateArray.append(today)
            
        }
        
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scoreArray.removeAll()
        textArray.removeAll()
        dateArray.removeAll()
        totalScore = 0
        let mouseArray: [Mouse] = AnonyMouseDB.instance.getMyMice(myMice: myPhoneID)
        for mice in mouseArray {
            totalScore = totalScore + mice.score
            textArray.append(mice.text)
            scoreArray.append(Int(mice.score))
            var today = mice.date
            today = Calendar.current.date(byAdding: .day, value: -3, to: today)!
            dateArray.append(today)
            
        }
        if let navigationBar = self.navigationController?.navigationBar {
            let firstFrame = CGRect(x: (navigationBar.frame.width)-(navigationBar.frame.width/3.5), y: 0, width: navigationBar.frame.width/2, height:navigationBar.frame.height)
            let secondFrame = CGRect(x: (navigationBar.frame.width/2)-(navigationBar.frame.width/9), y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
            if labelScore > 0 {
                firstLabel.alpha = 0
            }
            firstLabel = UILabel(frame: firstFrame)
            firstLabel.text = "My Score \(String(totalScore))"
            
            let secondLabel = UILabel(frame: secondFrame)
            secondLabel.text = "My Mice"
            
            
            labelScore += 1
            navigationBar.addSubview(firstLabel)
            navigationBar.addSubview(secondLabel)
        }
        color = 2
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell2
        
        cell.mineTextLabel.text = textArray[indexPath.row]
        let dateString: String = String(describing: (dateArray[indexPath.row]))
        let start = dateString.index(dateString.startIndex, offsetBy: 5)
        let end = dateString.index(dateString.startIndex, offsetBy: 15)
        let range = start...end
        let substring = dateString[range]
        cell.datePostedMineLabel.text = ("Posted on: \(substring)")
        if color % 2 == 0 {
            cell.backgroundColor = UIColor.lightGray
            cell.mineTextLabel.backgroundColor = UIColor.lightGray
        }
        else {
            cell.backgroundColor = UIColor.white
            cell.mineTextLabel.backgroundColor = UIColor.white
        }
        color += 1
        cell.mineScoreLabel.text = (String(scoreArray[indexPath.row]))

        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.mineTextLabel.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 8
        cell.mineTextLabel.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.mineTextLabel.clipsToBounds = true
        tableView.backgroundColor = UIColor.black

        if cell.buttonDelegate2 == nil {
            cell.buttonDelegate2 = self
        }
               return cell
    
    }
    
    
    func cellTapped2(_ cell: ButtonCell2) {
        let cellText = cell.mineTextLabel.text
        self.deleteMouse(cellText: cellText!, cellID: myPhoneID)
    }
    
    
    func deleteMouse(cellText: String, cellID: String) {
        AnonyMouseDB.instance.deleteAnonyMouse(cellText: cellText, cellID: cellID)
        AnonyMouseDB.instance.deleteMyAnonyMouse(cellText: cellText, cellID: cellID)
        update()
        
    }
    
    
    func update () {
        textArray.removeAll()
        scoreArray.removeAll()
        dateArray.removeAll()
        let mouseArray: [Mouse] = AnonyMouseDB.instance.getMyMice(myMice: myPhoneID)
        for mice in mouseArray {
            textArray.append(mice.text)
            scoreArray.append(Int(mice.score))
            var today = mice.date
            today = Calendar.current.date(byAdding: .day, value: -3, to: today)!
            dateArray.append(today)
            
        }
        color = 2
        refreshView()
        
    }
    func refreshView() {
        self.viewDidLoad()
        self.viewWillAppear(true)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.viewDidLoad()
        

    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        scoreArray.removeAll()
        textArray.removeAll()
        dateArray.removeAll()
 
        let mouseArray: [Mouse] = AnonyMouseDB.instance.getMyMice(myMice: myPhoneID)
        for mice in mouseArray {
                totalScore = totalScore + mice.score
                textArray.append(mice.text)
                scoreArray.append(Int(mice.score))
            var today = mice.date
            today = Calendar.current.date(byAdding: .day, value: -3, to: today)!
            dateArray.append(today)
            
            }

        

        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

