//
//  HabitController.swift
//  Habit Tracker
//
//  Created by David Sadler on 9/2/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HabitController {
    
    // MARK: - Singleton
    
    static let shared = HabitController()
    
    // MARK: - Fetched Habit Collection
    
    var habits: [Habit] {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        let moc = CoreDataStack.context
        do {
            let result = try moc.fetch(request)
            return result
        } catch {
            return []
        }
    }
    
    // MARK: - CRUD
    
    func createHabit(name: String,
                     userIntention: String?,
                     isNegativeHabit: Bool,
                     currentTimesDone: Int?,
                     image: UIImage,
                     colorID: Int,
                     habitDayInterval: Int,
                     desiredHabitFrequency: Int,
                     unitOfCount: String) {
        let imageData: Data?
        imageData = image.jpegData(compressionQuality: 1.0)
        _ = Habit(name: name, userIntention: userIntention, isNegativeHabit: isNegativeHabit, colorId: Int16(colorID), currentTimesDone: Int16(currentTimesDone ?? 0), desiredDayInterval: Int16(habitDayInterval), desiredFrequency: Int16(desiredHabitFrequency), image: imageData, lastUpdatedDate: Date(), lastTimeCountWasZero: Date(), unitOfCount: unitOfCount)
        saveToPersistentStorage()
    }
    
    func updateHabit(newName: String,
                     newIntention: String?,
                     newHabitQualifier: Bool,
                     newTimesDone: Int?,
                     newImage: UIImage,
                     newColorID: Int,
                     newHabitDayInterval: Int,
                     newHabitFrequency: Int,
                     habit: Habit) {
        let imageData: Data?
        imageData = newImage.jpegData(compressionQuality: 1.0)
        habit.name = newName
        habit.userIntention = newIntention
        habit.isNegativeHabit = newHabitQualifier
        habit.currentTimesDone = Int16(newTimesDone ?? 0)
        habit.image = imageData
        habit.colorId = Int16(newColorID)
        habit.desiredFrequency = Int16(newHabitFrequency)
        habit.desiredDayInterval = Int16(newHabitDayInterval)
        saveToPersistentStorage()
    }
    
    func deleteHabit(habit: Habit) {
        let moc = habit.managedObjectContext
        moc?.delete(habit)
        saveToPersistentStorage()
    }
    
    // MARK: - Helpers
    
    func newCurrentTimesDoneFor(habit: Habit,
                                  newCount: Int) {
        let new = Int16(newCount)
        habit.currentTimesDone = new
        saveToPersistentStorage()
    }
    
    func resetHabitCount(habit: Habit) {
        habit.currentTimesDone = 0
        habit.lastUpdatedDate = Date()
        habit.lastTimeCountWasZero = Date()
        saveToPersistentStorage()
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
