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


class AnonyMouseDB {
    static let instance = AnonyMouseDB()
    
    private var db: Connection? = nil
    private var dbMine: Connection? = nil
    
    var myMice: [Mouse] = []
    private let anonymouseMine = Table("anonymouseMine")
    private let anonymouse = Table("anonymouse")
    private let text = Expression<String>("text")
    private let score = Expression<Int64>("score")
    private let report = Expression<Int64>("report")
    private let latitude = Expression<Double>("latitude")
    private let longitude = Expression<Double>("longitude")
    private let date = Expression<Date>("date")
    private let phoneID = Expression<String>("phone")
    private let id = Expression<Int64>("id")


    
   private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            db = try Connection("\(path)/anonymouse.sqlite3")
            createTable()
            
            dbMine = try Connection("\(path)/anonymouseMine.sqlite3")
            createMyTable()
            
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
            let _ = try db!.run(anonyMouse.delete())
        } catch {
            print("AnonyMouse: Delete failed")
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
    
    
    func addScore(cellText: String, cellID: String) {
        do {
            let alice = anonymouse.filter(text == cellText && phoneID == cellID)
            let _ = try db!.run(alice.update(score++))
            
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
    
       
    func getAnonyMouse() -> [Mouse] {
        var anonyMouse: [Mouse] = []
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

                anonyMouse.append(m)
            }
        } catch {
            print("AnonyMouse: unable to read the table")
        }
        return anonyMouse
    }
    
    func getBestAnonyMouse() -> [Mouse] {
        var anonyMouse: [Mouse] = []
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

                    
                    anonyMouse.append(m)
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
    
    func getMyMice(myMice: String) -> [Mouse] {
        var anonyMouse: [Mouse] = []
        
        do {
            for anonymice in try dbMine!.prepare(anonymouseMine
                                    .filter(phoneID == myMice)){
                
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

    
    
    
}



