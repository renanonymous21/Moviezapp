//
//  DateFormat.swift
//  Moviezapp
//
//  Created by Rendy K. R on 10/03/21.
//

import Foundation

public func formatDateBasic(_ stringDate: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    if let date = formatter.date(from: stringDate) {
        formatter.dateFormat = "dd MMMM, yyyy"
        let newDate = formatter.string(from: date)
        return newDate
    }
    return "unknown date"
}

public func formatPosixDate(_ stringDate: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    if let date = formatter.date(from: stringDate) {
        formatter.dateFormat = "dd MMMM, yyyy HH:mm:ss"
        let newDate = formatter.string(from: date)
        return newDate
    }
    
    return "unknown date"
}
