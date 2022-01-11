//
//  Date+Utility.swift
//  HMD
//
//  Created by Yi JIANG on 18/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation

extension Date {

    func offsetBy(_ days: Int, hours: Int, minutes: Int) -> Date? {
        var dateComponent = DateComponents()
        dateComponent.day = days
        dateComponent.hour = hours
        dateComponent.minute = Int(minutes)
        return Calendar.current.date(byAdding: dateComponent, to: self)
    }
    
    func offsetBy(_ years: Int) -> Date? {
        var dateComponent = DateComponents()
        dateComponent.year = years
        return Calendar.current.date(byAdding: dateComponent, to: self)
    }
    
    /// Get the name of the part of the current day. 
    ///
    /// - Returns: A string representing the part of the current day: "Morning" or "Afternoon"
    var isMorning: Bool? {
        let now = Date()
        guard let noon = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: now) else { return nil }
        return now < noon
    }
}
