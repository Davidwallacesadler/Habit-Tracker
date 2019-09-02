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
        guard let habitName = habit.name else {
            return
        }
        let uuid = UUID()
        _ = HabitHistory(habitName: habitName, recordedFrequency: habit.currentTimesDone, recordingDate: Date(), uuid: uuid)
        // Want to reset the counter
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
    
    func deleteAllHistoryForHabit(habit: Habit) {
        guard let habitName = habit.name else {
            return
        }
        var historyForSelectedHabit = [HabitHistory]()
        for historyPoint in history {
            if historyPoint.habitName == habitName {
                historyForSelectedHabit.append(historyPoint)
            }
        }
        for desiredHabitPoint in historyForSelectedHabit {
            deleteHistoryPoint(habitHistoryPoint: desiredHabitPoint)
        }
    }
    
    // MARK: - Helpers
    
    func findHistoryById(idString: String) -> HabitHistory? {
        for habitHistoryPoint in history {
            if habitHistoryPoint.uuid?.uuidString == idString {
                return habitHistoryPoint
            } else {
                return nil
            }
        }
        return nil
    }
    
    // MARK: - Persistence
    
    func saveToPersistentStorage() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print(error)
        }
    }
}


