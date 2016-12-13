//
//  AnonyMouseDB.swift
//  Anonymouse
//
//  Created by Dominic Vernazza on 12/7/16.
//  Copyright © 2016 Dominic Vernazza. All rights reserved.
//

import Foundation
import SQLite
import UIKit
import MapKit


class AnonyMouseDB {
    static let instance = AnonyMouseDB()
    
    private var db: Connection? = nil
    private var dbMine: Connection? = nil
    private var dbLikes: Connection? = nil
    
    var myMice: [Mouse] = []
    private let anonymouseMine = Table("anonymouseMine")
    private let anonymouse = Table("anonymouse")
    private let anonymouseLikes = Table("anonymouseLikes")
    private let text = Expression<String>("text")
    private let score = Expression<Int64>("score")
    private let report = Expression<Int64>("report")
    private let latitude = Expression<Double>("latitude")
    private let longitude = Expression<Double>("longitude")
    private let date = Expression<Date>("date")
    private let phoneID = Expression<String>("phone")
    private let id = Expression<Int64>("id")
    private let likedCellID = Expression<String>("likedCellID")
    private let likedText = Expression<String>("likedText")
    private let yourCellID = Expression<String>("yourCellID")
    private let todayDate = Expression<Date>("todayDate")
    private let likedIt = Expression<Int>("likedIt")
    private let hatedIt = Expression<Int>("hatedIt")


    
   private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            db = try Connection("\(path)/anonymouse.sqlite3")
            createTable()
            
            dbMine = try Connection("\(path)/anonymouseMine.sqlite3")
            createMyTable()
            
            dbLikes = try Connection("\(path)/anonymouseLikes.sqlite3")
            createLikesTable()
            print("created")

       } catch {
         print("AnonyMouse: Unable to open the database")
        }
    }
    
    func createTable() {
        do {
            try db!.run(anonymouse.create { table in
                table.column(id, primaryKey: true)
                table.column(text)
                table.column(score)
                table.column(report)
                table.column(longitude)
               table.column(latitude)
                table.column(date)
               table.column(phoneID)

            })
        } catch {
           print("AnonyMouse: Unable to create table")
       }
    }
    
    func createLikesTable() {
        do {
            try dbLikes!.run(anonymouseLikes.create { table in
                table.column(likedCellID)
                table.column(likedText)
                table.column(yourCellID)
                table.column(todayDate)
                table.column(likedIt)
                table.column(hatedIt)
    
            })
        } catch {
            print("AnonyMouse: Unable to create table")
        }
    }
    
    func createMyTable() {
        do {
            try dbMine!.run(anonymouseMine.create { table in
                table.column(id, primaryKey: true)
                table.column(text)
                table.column(score)
                table.column(report)
                table.column(longitude)
                table.column(latitude)
                table.column(date)
                table.column(phoneID)
                
            })
        } catch {
            print("AnonyMouse: Unable to create table")
        }
    }


         func add(anonymice: Mouse) -> Int64? {
        do {
            let insert = anonymouse.insert(
                text <- anonymice.text,
                score <- Int64(anonymice.score),
                report <- Int64(anonymice.report),
                longitude <- anonymice.longitude!,
                latitude <- anonymice.latitude!,
                date <- anonymice.date,
                phoneID <- anonymice.phoneID)

            let id = try db!.run(insert)

            return id

            
        } catch {
            print("AnonyMouse: Insert failed")
            return nil
        }
    }
    
    func addMine(anonymice: Mouse) {
        do {
            let insert = anonymouseMine.insert(
                text <- anonymice.text,
                score <- Int64(anonymice.score),
                report <- Int64(anonymice.report),
                longitude <- anonymice.longitude!,
                latitude <- anonymice.latitude!,
                date <- anonymice.date,
                phoneID <- anonymice.phoneID)
            
                try dbMine!.run(insert)
            
            
            
        } catch {
            print("AnonyMouse: Insert failed")
        }
        
    }
    
    
    
    func addLikes(anonymice: Liked) {
        do {
            let insert = anonymouseLikes.insert(
                likedText <- anonymice.likedText,
                likedCellID <- anonymice.likedCellID,
                yourCellID <- anonymice.yourCellID,
                todayDate <- anonymice.todayDate,
                likedIt <- anonymice.likedIt,
                hatedIt <- anonymice.hatedIt)

            
            try dbLikes!.run(insert)
            
   
        } catch {
            print("AnonyMouse: Insert failed yo")
        }
        
    }
    
    
    
    func deleteAnonyMouse(cellText: String, cellID: String) {
        do {

            let anonyMouse = anonymouse.filter(text == cellText && phoneID == cellID)
            let _ = try db!.run(anonyMouse.delete())
        } catch {
            print("AnonyMouse: Delete failed")
        }
        
    }
    
    func deleteMyAnonyMouse(cellText: String, cellID: String) {
        do {
            
            let anonyMouse = anonymouseMine.filter(text == cellText && phoneID == cellID)
            let _ = try dbMine!.run(anonyMouse.delete())
        } catch {
            print("AnonyMouse: Deletion failed")
        }
        
    }
    
    func deleteDate() {
        let today: Date = Date()

        do {
            let anonyMouse = anonymouse.filter(date < today)
            let _ = try db!.run(anonyMouse.delete())
        } catch {
            print("AnonyMouse: Delete failed")
        }
        
    }
    
    func clear() {
        do {
            let _ = try dbLikes!.run(anonymouseLikes.delete())
            print("cleared")
        } catch {
            print("AnonyMouse: Delete failed")

        }
    }
    
    
    func addScore(cellText: String, cellID: String) {
        do {
            let alice = anonymouse.filter(text == cellText && phoneID == cellID)
            let _ = try db!.run(alice.update(score++))
            
        } catch {
            print("AnonyMouse: Couldn't update score")
        }
    }
    
    func addMyScore(cellText: String, cellID: String) {
        do {
            let alice = anonymouseMine.filter(text == cellText && phoneID == cellID)
            let _ = try dbMine!.run(alice.update(score++))
            
        } catch {
            print("AnonyMouse: Couldn't update score")
        }
    }
    
    func downScore(cellText: String, cellID: String) {
        do {
            let alice = anonymouse.filter(text == cellText && phoneID == cellID)
            let _ = try db!.run(alice.update(score--))
            
        } catch {
            print("AnonyMouse: Couldn't update score")
        }
        
    }
    
    func downMyScore(cellText: String, cellID: String) {
        do {
            let alice = anonymouseMine.filter(text == cellText && phoneID == cellID)
            let _ = try dbMine!.run(alice.update(score--))
            
        } catch {
            print("AnonyMouse: Couldn't update score")
        }
        
    }
    
    func getScore(cellText: String, cellID: String) -> Int {
        var points: Int = 0
        do {
            let alice = anonymouse.filter(text == cellText && phoneID == cellID)
            for anonymice in try db!.prepare(alice) {
                let m = Mouse(id: anonymice[id])
                m.score = anonymice[score]
                points = Int(m.score)
            }
        } catch {
            print("AnonyMouse: unable to read the table")
        }
        return points
    }
    
    func addReport(cellText: String, cellID: String) {
        do {
            let alice = anonymouse.filter(text == cellText && phoneID == cellID)
            let _ = try db!.run(alice.update(report++))
            
        } catch {
            print("AnonyMouse: Couldn't update report")
        }
    }
    
    func getReport(cellText: String, cellID: String) -> Int {
        var reportScore: Int = 0
        do {
            let alice = anonymouse.filter(text == cellText && phoneID == cellID)
            for anonymice in try db!.prepare(alice) {
                let m = Mouse(id: anonymice[id])
                m.report = anonymice[report]
                reportScore = Int(m.report)
            }
        } catch {
            print("AnonyMouse: unable to read the table")
        }
        return reportScore
    }
    
       
    func getAnonyMouse(userLocation: CLLocation) -> [Mouse] {
        var anonyMouse: [Mouse] = []
        var mouseLocation: CLLocation? = nil
        var distance: Double = 0.0
        let today: Date = Date()
        do {
            for anonymice in try db!.prepare(self.anonymouse
                                    .filter(date >= today)
                                    .order(date.desc)) {
                
                let m = Mouse(id: anonymice[id])
                m.score = anonymice[score]
                m.text = anonymice[text]
                m.report = anonymice[report]
                m.longitude = anonymice[longitude]
                m.latitude = anonymice[latitude]
                m.date = anonymice[date]
                m.phoneID = anonymice[phoneID]
                                        
                mouseLocation = CLLocation(latitude: m.latitude!, longitude: m.longitude!)
                distance = userLocation.distance(from: mouseLocation!)
                if distance <= 3218.688 {
                                        
                anonyMouse.append(m)
            }
            }
        } catch {
            print("AnonyMouse: unable to read the table")
        }
        return anonyMouse
    }
    
    func getBestAnonyMouse(userLocation: CLLocation) -> [Mouse] {
        var anonyMouse: [Mouse] = []
        var mouseLocation: CLLocation? = nil
        var distance: Double = 0.0
        let today: Date = Date()
               do {
            for anonymice in try db!.prepare(anonymouse
                .filter(date >= today)
                .order(score.desc)) {
                    let m = Mouse(id: anonymice[id])
                    m.score = anonymice[score]
                    m.text = anonymice[text]
                    m.report = anonymice[report]
                    m.longitude = anonymice[longitude]
                    m.latitude = anonymice[latitude]
                    m.date = anonymice[date]
                    m.phoneID = anonymice[phoneID]
                    
                    mouseLocation = CLLocation(latitude: m.latitude!, longitude: m.longitude!)
                    distance = userLocation.distance(from: mouseLocation!)
                    if distance <= 3218.688 {
                    
                    anonyMouse.append(m)
                    }
            }
        } catch {
            print("AnonyMouse: unable to read the table")
        }
        return anonyMouse
        
    }
 
    
    
    func beenPosted(phoneNumber: String, textBox: String) -> Bool {
        var count: Int = 1
        var truth: Bool? = nil
        var anonyMouse: [Mouse] = []
        do {
            
            for anonymice in try db!.prepare(anonymouse.filter(phoneID == phoneNumber && text == textBox)) {
                let m = Mouse(id: anonymice[id])
                m.score = anonymice[score]
                m.text = anonymice[text]
                m.report = anonymice[report]
                m.longitude = anonymice[longitude]
                m.latitude = anonymice[latitude]
                m.date = anonymice[date]
                m.phoneID = anonymice[phoneID]

                anonyMouse.append(m)
            
                    
            }
        }catch {
                print("AnonyMouse: unable to read the table")
            
            }
        count = anonyMouse.count
        
        if count > 0 {
            truth = true
        } else {
            truth = false
        }
            return truth!
            }
    
    
    func beenLiked(likedPhoneNumber: String, likedMouse: String, yourPhoneNumber: String) -> Int {
        var count: Int = 1
        var liked: Int = 0
        var anonyMouse: [Liked] = []
        
        do {
            
            for likes in try dbLikes!.prepare(anonymouseLikes.filter(likedCellID == likedPhoneNumber && likedText == likedMouse && yourCellID == yourPhoneNumber)) {
                let m = Liked(likedText: likes[likedText],likedCellID: likes[likedCellID], yourCellID: likes[yourCellID])
                m.likedIt = likes[likedIt]
                m.hatedIt = likes[hatedIt]
                anonyMouse.removeAll()
                anonyMouse.append(m)
                
                
            }
        }catch {
            print("AnonyMouse: unable to read the table")
            
        }
        count = anonyMouse.count
        if count > 0 {

            if anonyMouse[0].likedIt == 1 {
                liked = 2
            }

            else if anonyMouse[0].hatedIt == 1 {
                liked = 1
            }
            else {}
            
            
        } else {
            liked = 0
        }
        return liked
    }
    

    
    
    
    
    func getMyMice(myMice: String) -> [Mouse] {
        var anonyMouse: [Mouse] = []
        
        do {
            for anonymice in try dbMine!.prepare(anonymouseMine
                                    .filter(phoneID == myMice)
                                    .order(date.desc)){
                
                let m = Mouse(id: anonymice[id])
                m.score = anonymice[score]
                m.text = anonymice[text]
                m.report = anonymice[report]
                m.longitude = anonymice[longitude]
                m.latitude = anonymice[latitude]
                m.date = anonymice[date]
                m.phoneID = anonymice[phoneID]

                anonyMouse.append(m)
            }
        } catch {
            print("AnonyMouse: unable to read the table")
        }
        return anonyMouse
}

    
    func updateLikedIt(likedMouse: String, likedPhoneNumber: String, yourPhoneNumber: String) {
        
        do {
        let alice = anonymouseLikes.filter(likedText == likedPhoneNumber && likedText == likedMouse && yourCellID == yourPhoneNumber)
        let _ = try dbLikes!.run(alice.delete())
            
    } catch {
    print("AnonyMouse: unable to read the table like")
    }
    
}
    
    func updateHatedIt(likedMouse: String, likedPhoneNumber: String, yourPhoneNumber: String) {
        
        do {
            let alice = anonymouseLikes.filter(likedText == likedPhoneNumber && likedText == likedMouse && yourCellID == yourPhoneNumber)
            let _ = try dbLikes!.run(alice.delete())
        } catch {
            print("AnonyMouse: unable to read the table hate")
        }
        
    }
    


}

