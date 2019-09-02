//
//  HabitHistory+Convenience.swift
//  Habit Tracker
//
//  Created by David Sadler on 9/2/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import CoreData

extension HabitHistory {
    convenience init(habitName: String,
                     recordedFrequency: Int16,
                     recordingDate: Date,
                     context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.habitName = habitName
        self.recordedFrequency = recordedFrequency
        self.recordingDate = recordingDate
    }
}
