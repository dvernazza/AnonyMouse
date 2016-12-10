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
    var report: Int64
    var score: Int64
    var picture: UIImage?
    var coordinate: CLLocationCoordinate2D?
    var longitude: CLLocationDegrees?
    var latitude: CLLocationDegrees?
    var phoneID: String
    var id: Int64?


    
    init(id: Int64) {
        self.text = ""
        self.date = NSDate() as Date
        self.report = 0
        self.score = 0
        self.picture = nil
        self.phoneID = ""
        self.longitude = nil
        self.latitude = nil
        self.id = id
        self.coordinate = nil
  
        
    }
}
