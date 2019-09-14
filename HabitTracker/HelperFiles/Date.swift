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
}
