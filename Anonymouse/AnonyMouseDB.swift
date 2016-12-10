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
    
    func deleteAnonyMouse(aId: Int64) {
        do {
            let anonyMouse = anonymouse.filter(id == aId)
            let _ = try db!.run(anonyMouse.delete())
        } catch {
            print("AnonyMouse: Delete failed")
        }
        
    }
    
    func addScore(aId: Int64) {
        do {
            let alice = anonymouse.filter(id == aId)
            let _ = try db!.run(alice.update(score++))
            
        } catch {
            print("AnonyMouse: Couldn't update score")
        }
    }
    
       
    func getAnonyMouse() -> [Mouse] {
        var anonyMouse: [Mouse] = []
        
        do {
            for anonymice in try db!.prepare(self.anonymouse) {
                
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
        
        do {
            for anonymice in try db!.prepare(anonymouse
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
 
    func returnScore(aId: Int64) -> Int {
        var points: Int = 0
        do {
            for anonymice in try db!.prepare(anonymouse
                .filter(id == aId)) {
                let m = Mouse(id: anonymice[id])
                    m.score = anonymice[score]
                    points = Int(m.score)
            }
            
        } catch {
            print("AnonyMouse: unable to read the table")
        }
        return Int(points)
    }
    
    func beenPosted(phoneNumber: String, textBox: String) -> Bool {
         var count = 0
        var truth: Bool? = nil
        do {
             count = try db!.scalar(anonymouse.filter(phoneID == phoneNumber)
                .filter(text == textBox).count) {
                    if count > 0 {
                        truth = true
                    } else {
                        truth = false
                    }
                    
            }
        }catch {
                print("AnonyMouse: unable to read the table")
            
            }
            return truth!
            }
}
    
    

