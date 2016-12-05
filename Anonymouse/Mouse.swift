//
//  Mouse.swift
//  Anonymouse
//
//  Created by Dominic Vernazza on 11/28/16.
//  Copyright © 2016 Dominic Vernazza. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Mouse {
    var text: String
    var date: Date
    var report: Int
    var score: Int
    var picture: UIImage?
    var coordinate: CLLocationCoordinate2D?
    var mouseID: String


    
    init() {
        self.text = ""
        self.date = NSDate() as Date
        self.report = 0
        self.score = 0
        self.picture = nil
        self.coordinate = nil
        self.mouseID = ""
  
        
    }
}
