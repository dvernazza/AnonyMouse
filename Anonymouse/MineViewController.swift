//
//  MineViewController.swift
//  Anonymouse
//
//  Created by Dominic Vernazza on 12/9/16.
//  Copyright © 2016 Dominic Vernazza. All rights reserved.
//
import MapKit
import UIKit

class MineViewController: UITableViewController, ButtonCellDelegate2 {
    let myPhoneID = UIDevice.current.identifierForVendor!.uuidString
    var textArray: [String] = []
    var scoreArray: [Int] = []
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mouseArray: [Mouse] = AnonyMouseDB.instance.getMyMice(myMice: myPhoneID)
        for mice in mouseArray {
            
            textArray.append(mice.text)
            scoreArray.append(Int(mice.score))

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "mine", for: indexPath) as! ButtonCell2
        
        cell.textLabel?.text = textArray[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = (String(scoreArray[indexPath.row]))
        cell.totalScoreLabel.text = String(AnonyMouseDB.instance.returnScore(userID: myPhoneID))
        if cell.buttonDelegate2 == nil {
            cell.buttonDelegate2 = self
        }
        return cell
    }
    
    func cellTapped2(_ cell: ButtonCell2) {
        let cellText = cell.textLabel?.text
        print("tapped \(cellText)")
        self.deleteMouse(cellText: cellText!, cellID: myPhoneID)
    }
    
    
    func deleteMouse(cellText: String, cellID: String) {
        AnonyMouseDB.instance.deleteAnonyMouse(cellText: cellText, cellID: cellID)
        update()
        
    }
    
    
    func update () {
        textArray.removeAll()
        scoreArray.removeAll()
        let mouseArray: [Mouse] = AnonyMouseDB.instance.getMyMice(myMice: myPhoneID)
        for mice in mouseArray {
            textArray.append(mice.text)
            scoreArray.append(Int(mice.score))
            
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
