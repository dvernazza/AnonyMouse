//
//  NewTableViewController.swift
//  Anonymouse
//
//  Created by Dominic Vernazza on 11/28/16.
//  Copyright © 2016 Dominic Vernazza. All rights reserved.
//

import UIKit
import MapKit

class NewTableViewController: UITableViewController, CLLocationManagerDelegate, UITabBarControllerDelegate, ButtonCellDelegate3 {
    var scoreArray: [Int] = []
    var textArray: [String] = []
    var color: Int = 2
    var dateArray: [Date] = []
    let bestPhoneID = UIDevice.current.identifierForVendor!.uuidString
    let locationManager = CLLocationManager()
    var phoneIDArray: [String] = []
    var myNewLocation: CLLocation? = nil
    var newOnce = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        self.refreshControl?.addTarget(self, action: #selector(NewTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView.delegate = self
        scoreArray.removeAll()
        textArray.removeAll()
        phoneIDArray.removeAll()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
        
        if newOnce > 0 {
            let mouseArray: [Mouse] = AnonyMouseDB.instance.getAnonyMouse(userLocation: myNewLocation!)
        
        for mice in mouseArray {
            
            textArray.append(mice.text)
            scoreArray.append(Int(mice.score))
            phoneIDArray.append(mice.phoneID)
            dateArray.append(mice.date)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    }
    override func viewWillAppear(_ animated: Bool) {
        scoreArray.removeAll()
        textArray.removeAll()
        phoneIDArray.removeAll()
        color = 2
        if newOnce > 0 {
            let mouseArray: [Mouse] = AnonyMouseDB.instance.getAnonyMouse(userLocation: myNewLocation!)
            
            for mice in mouseArray {
                textArray.append(mice.text)
                scoreArray.append(Int(mice.score))
                phoneIDArray.append(mice.phoneID)
                dateArray.append(mice.date)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])  {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        let myLocation : CLLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        myNewLocation = myLocation
        if newOnce == 0 {
            newOnce += 1
            self.viewWillAppear(false)
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
        let dateString: String = String(describing: (dateArray[indexPath.row]))
        let start = dateString.index(dateString.startIndex, offsetBy: 5)
        let end = dateString.index(dateString.startIndex, offsetBy: 15)
        let range = start...end
        let substring = dateString[range]
        cell.datedPostedOn.text = ("Posted on: \(substring)")
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
        
        if (AnonyMouseDB.instance.beenLiked(likedPhoneNumber: cell.subTitleLabel.text!, likedMouse: cell.newMouseText.text!, yourPhoneNumber: bestPhoneID)) == 2 {
            cell.newUpButton.alpha = 0
            cell.newDownButton.alpha = 1
            
        }
        else if (AnonyMouseDB.instance.beenLiked(likedPhoneNumber: cell.subTitleLabel.text!, likedMouse: cell.newMouseText.text!, yourPhoneNumber: bestPhoneID)) == 1 {
            cell.newDownButton.alpha = 0
            cell.newUpButton.alpha = 1
        }

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
    
    func reportCellTapped3(_ cell: ButtonCell3) {
        let cellText = cell.newMouseText.text
        let cellID = cell.subTitleLabel.text
        self.addReport(cellText: cellText!, cellID: cellID!)
    }
    
    func downCellTapped3(_ cell: ButtonCell3) {
        let cellText = cell.newMouseText.text
        let cellID = cell.subTitleLabel.text
        self.downScore(cellText: cellText!, cellID: cellID!)
    }
    
    func addScore(cellText: String, cellID: String) {
        AnonyMouseDB.instance.addScore(cellText: cellText, cellID: cellID)
        AnonyMouseDB.instance.addMyScore(cellText: cellText, cellID: cellID)
        let liked: Liked = Liked(likedText: cellText, likedCellID: cellID, yourCellID: bestPhoneID)
        liked.likedIt = 1
        AnonyMouseDB.instance.updateLikedIt(likedMouse: cellText, likedPhoneNumber: cellID, yourPhoneNumber: bestPhoneID)
        AnonyMouseDB.instance.addLikes(anonymice: liked)
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
        let liked: Liked = Liked(likedText: cellText, likedCellID: cellID, yourCellID: bestPhoneID)
        liked.hatedIt = 1
        AnonyMouseDB.instance.updateHatedIt(likedMouse: cellText, likedPhoneNumber: cellID, yourPhoneNumber: bestPhoneID)
        AnonyMouseDB.instance.addLikes(anonymice: liked)
        if (AnonyMouseDB.instance.getScore(cellText: cellText, cellID: cellID)) <= -5 {
            AnonyMouseDB.instance.deleteAnonyMouse(cellText: cellText, cellID: cellID)
        }
        update()
    }



    
    
    func update () {
        textArray.removeAll()
        scoreArray.removeAll()
        dateArray.removeAll()
        let mouseArray: [Mouse] = AnonyMouseDB.instance.getAnonyMouse(userLocation: myNewLocation!)
        for mice in mouseArray {
            textArray.append(mice.text)
            scoreArray.append(Int(mice.score))
            dateArray.append(mice.date)
            AnonyMouseDB.instance.deleteDate()
            
        }
        self.viewWillAppear(true)
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        scoreArray.removeAll()
        textArray.removeAll()
        phoneIDArray.removeAll()
        
        let mouseArray: [Mouse] = AnonyMouseDB.instance.getAnonyMouse(userLocation: myNewLocation!)
        
        for mice in mouseArray {
      
            textArray.append(mice.text)
            scoreArray.append(Int(mice.score))
            phoneIDArray.append(mice.phoneID)
        }

        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

}
