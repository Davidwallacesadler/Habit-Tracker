//
//  Habit+Convenience.swift
//  Habit Tracker
//
//  Created by David Sadler on 9/2/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension Habit {
    var photo: UIImage {
        guard let image = image else { return UIImage() }
        guard let photo = UIImage(data: image as Data) else { return UIImage() }
        return photo
    }
    convenience init(name: String,
                     userIntention: String,
                     isNegativeHabit: Bool,
                     colorId: Int16,
                     currentTimesDone: Int16,
                     desiredDayInterval: Int16,
                     desiredFrequency: Int16,
                     image: Data?,
                     lastUpdatedDate: Date,
                     context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.userIntention = userIntention
        self.isNegativeHabit = isNegativeHabit
        self.colorId = colorId
        self.currentTimesDone = currentTimesDone
        self.desiredDayInterval = desiredDayInterval
        self.desiredFrequency = desiredFrequency
        self.image = image
        self.lastUpdatedDate = lastUpdatedDate
    }
}
