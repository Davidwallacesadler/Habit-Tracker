//
//  DateHelpers.swift
//  Habit Tracker
//
//  Created by David Sadler on 9/5/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

struct DateHelper {
    
    // MARK: - Singleton
    
    static let shared = DateHelper()
    
    // MARK: - Methods
    
    func isTargetDateMoreThanADayAwayFromToday(givenTargetDate date: Date) -> Bool {
        let current = Calendar.current
        let targetComponents = current.dateComponents([.year, .month, .day], from: date)
        let nowComponents = current.dateComponents([.year, .month, .day] , from: Date())
        guard let targetYear = targetComponents.year, let targetMonth = targetComponents.month, let targetDay = targetComponents.day, let nowYear = nowComponents.year, let nowMonth = nowComponents.month, let nowDay = nowComponents.day else { return false }
        if targetYear == nowYear {
            if targetMonth == nowMonth {
                if targetDay == nowDay {
                    return false
                } else {
                    return true
                }
            }
        }
        return false
    }
    
    func areTwoDatesOnDiffernetDays(dateOne: Date, dateTwo: Date) -> Bool {
        let current = Calendar.current
        let dateOneComponents = current.dateComponents([.year, .month, .day], from: dateOne)
        let dateTwoComponents = current.dateComponents([.year, .month, .day] , from: dateTwo)
        guard let dateOneYear = dateOneComponents.year, let dateOneMonth = dateOneComponents.month, let dateOneDay = dateOneComponents.day, let dateTwoYear = dateTwoComponents.year, let dateTwoMonth = dateTwoComponents.month, let dateTwoDay = dateTwoComponents.day else { return false }
        if dateOneYear == dateTwoYear {
            if dateOneMonth == dateTwoMonth {
                if dateOneDay == dateTwoDay {
                    return false
                } else {
                    return true
                }
            }
        }
        return false
    }
}
