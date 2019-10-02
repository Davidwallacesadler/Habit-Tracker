//
//  Date.swift
//  HabitTracker
//
//  Created by David Sadler on 9/8/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

extension Date {
    
    func stringValue() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
    
    func stringValueWithoutTime() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
    
    func weekMonthYear() -> [Int] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekOfMonth,.month,.year], from: self)
        guard let week = components.weekOfMonth, let month = components.month, let year = components.year else { return [] }
        return [week,month,year]
    }
}
