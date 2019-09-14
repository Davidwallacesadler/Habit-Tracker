//
//  HabitHistoryController.swift
//  Habit Tracker
//
//  Created by David Sadler on 9/2/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import CoreData

class HabitHistoryController {
    
    // MARK: - Singleton
    
    static let shared = HabitHistoryController()
    
    // MARK: - Fetched History Collection
    
    var history: [HabitHistory] {
        let request: NSFetchRequest<HabitHistory> = HabitHistory.fetchRequest()
        let moc = CoreDataStack.context
        do {
            let result = try moc.fetch(request)
            return result
        } catch {
            return []
        }
    }
    
    // MARK: - CRUD
    
    func createHistoryFor(habit: Habit) {
        guard let lastTimeUpdated = habit.lastUpdatedDate else {
            return
        }
        let historyPoint = HabitHistory(recordedFrequency: habit.currentTimesDone, recordingDate: lastTimeUpdated)
        habit.addToHistory(historyPoint)
        saveToPersistentStorage()
    }
    
    func updateHistoryPoint(habitHistoryPoint: HabitHistory,
                       newHabitCount: Int) {
        habitHistoryPoint.recordedFrequency = Int16(newHabitCount)
        habitHistoryPoint.recordingDate = Date()
        saveToPersistentStorage()
    }
    
    func deleteHistoryPoint(habitHistoryPoint: HabitHistory) {
        let moc = habitHistoryPoint.managedObjectContext
        moc?.delete(habitHistoryPoint)
        saveToPersistentStorage()
    }
    
    // MARK: - Helpers
    
    // MARK: - Persistence
    
    func saveToPersistentStorage() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print(error)
        }
    }
}


