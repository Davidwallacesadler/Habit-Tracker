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
    
    func monthAndYear() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month,.year], from: self)
        guard let month = components.month, let year = components.year else { return "" }
        var monthAndYear = ""
        switch month {
        case 1:
            monthAndYear = "January"
        case 2:
            monthAndYear = "February"
        case 3:
            monthAndYear = "March"
        case 4:
            monthAndYear = "April"
        case 5:
            monthAndYear = "May"
        case 6:
            monthAndYear = "June"
        case 7:
            monthAndYear = "July"
        case 8:
            monthAndYear = "August"
        case 9:
            monthAndYear = "September"
        case 10:
            monthAndYear = "October"
        case 11:
            monthAndYear = "November"
        default:
            monthAndYear = "December"
        }
        monthAndYear += " \(year)"
        return monthAndYear
    }
    
      func weekDay() -> String {
          let calendar = Calendar.current
          let weekDayComponent = calendar.dateComponents([.weekday], from: self)
          guard let weekDay = weekDayComponent.weekday else { return "" }
          switch weekDay {
          case 1:
              return "Sunday"
          case 2:
              return "Monday"
          case 3:
              return "Tuesday"
          case 4:
              return "Wednesday"
          case 5:
              return "Thursday"
          case 6:
              return "Friday"
          default:
              return "Saturday"
          }
      }
}
