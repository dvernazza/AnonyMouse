//
//  ScoreHolder.swift
//  Anonymouse
//
//  Created by Dominic Vernazza on 12/10/16.
//  Copyright © 2016 Dominic Vernazza. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ScoreHolder {

    var score: Int64
    var id: Int64?
    var text: String
    
    
    
    init(id: Int64, score: Int, text: String) {
        self.score = Int64(score)
        self.id = id
        self.text = text
    }
}
