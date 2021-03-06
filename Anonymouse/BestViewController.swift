//
//  BestViewController.swift
//  Anonymouse
//
//  Created by Dominic Vernazza on 12/9/16.
//  Copyright © 2016 Dominic Vernazza. All rights reserved.
//
import MapKit
import UIKit

class BestViewController: UITableViewController, UITabBarControllerDelegate, CLLocationManagerDelegate, ButtonCellDelegate {
   let bestPhoneID = UIDevice.current.identifierForVendor!.uuidString
    var scoreArray: [Int] = []
    var textArray: [String] = []
    var dateArray: [Date] = []
    let locationManager = CLLocationManager()
    var phoneIDArray: [String] = []
    var color: Int = 2
    var myBestLocation: CLLocation? = nil
    var once = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(NewTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView.delegate = self
        self.tabBarController?.delegate = self
        scoreArray.removeAll()
        textArray.removeAll()
        phoneIDArray.removeAll()
        dateArray.removeAll()
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
        if let navigationBar = self.navigationController?.navigationBar {
            let secondFrame = CGRect(x: (navigationBar.frame.width/2)-(navigationBar.frame.width/9), y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
            let secondLabel = UILabel(frame: secondFrame)
            secondLabel.text = "Best Mice"
            navigationBar.addSubview(secondLabel)
        }

        if once > 0 {
            let mouseArray: [Mouse] = AnonyMouseDB.instance.getBestAnonyMouse(userLocation: myBestLocation!)
            for mice in mouseArray {
                textArray.append(mice.text)
                scoreArray.append(Int(mice.score))
                phoneIDArray.append(mice.phoneID)
                var today = mice.date
                today = Calendar.current.date(byAdding: .day, value: -3, to: today)!
                dateArray.append(today)
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
        dateArray.removeAll()
        color = 2
        if once > 0 {
            let mouseArray: [Mouse] = AnonyMouseDB.instance.getBestAnonyMouse(userLocation: myBestLocation!)
            
            for mice in mouseArray {
                textArray.append(mice.text)
                scoreArray.append(Int(mice.score))
                phoneIDArray.append(mice.phoneID)
                var today = mice.date
                today = Calendar.current.date(byAdding: .day, value: -3, to: today)!
                dateArray.append(today)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])  {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        let myLocation : CLLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        myBestLocation = myLocation
        if once == 0 {
            once += 1
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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
        cell.anonymouseText.text = (textArray[indexPath.row])
        let dateString: String = String(describing: (dateArray[indexPath.row]))
        let start = dateString.index(dateString.startIndex, offsetBy: 5)
        let end = dateString.index(dateString.startIndex, offsetBy: 15)
        let range = start...end
        let substring = dateString[range]
        cell.datePosted.text = ("Posted on: \(substring)")
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
        
        if (AnonyMouseDB.instance.beenLiked(likedPhoneNumber: cell.subtitleLabel.text!, likedMouse: cell.anonymouseText.text!, yourPhoneNumber: bestPhoneID)) == 2 {
           cell.upButton.alpha = 0
            cell.downButton.alpha = 1
           
        }
        else if (AnonyMouseDB.instance.beenLiked(likedPhoneNumber: cell.subtitleLabel.text!, likedMouse: cell.anonymouseText.text!, yourPhoneNumber: bestPhoneID)) == 1 {
            cell.downButton.alpha = 0
            cell.upButton.alpha = 1
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
        phoneIDArray.removeAll()
        let mouseArray: [Mouse] = AnonyMouseDB.instance.getBestAnonyMouse(userLocation: myBestLocation!)
        for mice in mouseArray {
            textArray.append(mice.text)
            scoreArray.append(Int(mice.score))
            var today = mice.date
            today = Calendar.current.date(byAdding: .day, value: -3, to: today)!
            dateArray.append(today)
            phoneIDArray.append(mice.phoneID)
            AnonyMouseDB.instance.deleteDate()
    }
        self.refreshView()
    }
    
    func refreshView() {
        self.viewWillAppear(false)
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        scoreArray.removeAll()
        textArray.removeAll()
        phoneIDArray.removeAll()
        dateArray.removeAll()
        
        let mouseArray: [Mouse] = AnonyMouseDB.instance.getBestAnonyMouse(userLocation: myBestLocation!)
        
        for mice in mouseArray {
            textArray.append(mice.text)
            scoreArray.append(Int(mice.score))
            phoneIDArray.append(mice.phoneID)
            var today = mice.date
            today = Calendar.current.date(byAdding: .day, value: -3, to: today)!
            dateArray.append(today)
        }

        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    


}


