//
//  Liked.swift
//  Anonymouse
//
//  Created by Dominic Vernazza on 12/11/16.
//  Copyright © 2016 Dominic Vernazza. All rights reserved.
//

import Foundation

class Liked {
    var likedText: String
    var likedCellID: String
    var yourCellID: String
    var todayDate: Date
    var likedIt: Int
    var hatedIt: Int
    
    
    init(likedText: String, likedCellID: String, yourCellID: String) {
        self.likedText = likedText
        self.likedCellID = likedCellID
        self.yourCellID = yourCellID
        let thisDay = Date()
        self.todayDate = Calendar.current.date(byAdding: .day, value: 3, to: thisDay)!
        self.likedIt = 0
        self.hatedIt = 0
    }
}
