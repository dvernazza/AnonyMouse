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
    var idArray: [Int] = []
    var scoreHolderArray: [ScoreHolder] = []
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let mouseArray: [Mouse] = AnonyMouseDB.instance.getBestAnonyMouse()
        
            for mice in mouseArray {
                print(mice.text)
                textArray.append(mice.text)
                scoreArray.append(Int(mice.score))
                idArray.append(Int(mice.id!))
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
        
        cell.titleLabel.text = (textArray[indexPath.row] + "      " + String(scoreArray[indexPath.row]))
        cell.titleLabel.numberOfLines = 0
        var scoreHolder = ScoreHolder(id: Int64(idArray[indexPath.row]), score: scoreArray[indexPath.row], text: textArray[indexPath.row] )
        scoreHolderArray.append(scoreHolder)
        
        if cell.buttonDelegate == nil {
            cell.buttonDelegate = self
        }
        return cell
    }
    func cellTapped(_ cell: ButtonCell) {
        
        self.addScore(row: (tableView.indexPath(for: cell)! as NSIndexPath).row)
    }
    

        func addScore(row: Int) {
            AnonyMouseDB.instance.addScore(aId: (Int64(row)))
            update()
            
    }
    
    
    func update () {
        textArray.removeAll()
        scoreArray.removeAll()
        let mouseArray: [Mouse] = AnonyMouseDB.instance.getBestAnonyMouse()
        for mice in mouseArray {
            print(mice.text)
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



