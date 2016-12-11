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
    
    var myMice: [Mouse] = []
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
            print("add success")
            return id

            
        } catch {
            print("AnonyMouse: Insert failed")
            return nil
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
    
    func addScore(cellText: String, cellID: String) {
        do {
            let alice = anonymouse.filter(text == cellText && phoneID == cellID)
            let _ = try db!.run(alice.update(score++))
            
        } catch {
            print("AnonyMouse: Couldn't update score")
        }
    }
    
       
    func getAnonyMouse() -> [Mouse] {
        var anonyMouse: [Mouse] = []
        let today: Date = Date()
        let expirationDate = Calendar.current.date(byAdding: .day, value: 3, to: today)
        do {
            for anonymice in try db!.prepare(self.anonymouse
                                    .filter(date <= expirationDate!)
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
        let expirationDate = Calendar.current.date(byAdding: .day, value: 3, to: today)
        do {
            for anonymice in try db!.prepare(anonymouse
                .filter(date <= expirationDate!)
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
 
    func returnScore(userID: String) -> Int {
        var points = 0
        do {
            let alice = anonymouse.filter(phoneID == userID)
            let scoreRow = alice.select(score)
            points = try db!.scalar(scoreRow.count)

            
        } catch {
            print("AnonyMouse: unable to read the table")
        }
        return Int(points)
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
            for anonymice in try db!.prepare(anonymouse
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



