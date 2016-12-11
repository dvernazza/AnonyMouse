//
//  Date.swift
//  Anonymouse
//
//  Created by Dominic Vernazza on 12/10/16.
//  Copyright © 2016 Dominic Vernazza. All rights reserved.
//


import Foundation
import SQLite
import UIKit


extension Date {
    static var declareDatatype: String {
        return String.declaredDatatype
    }
    static func fromDatatypeValue(stringValue: String) -> Date {
        return SQLDateFormatter.date(from: stringValue)!
    }
    var datatypeValue: String {
        return SQLDateFormatter.string(from: self)
    }
}

let SQLDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}()
