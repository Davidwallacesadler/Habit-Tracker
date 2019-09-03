//
//  ColorHelper.swift
//  Habit Tracker
//
//  Created by David Sadler on 9/3/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import UIKit

struct ColorHelper {
    static func colorFrom(colorNumber: Int16) -> UIColor {
        switch colorNumber {
        case 1:
            return UIColor.brightRed_one
        case 2:
            return UIColor.redOrange_two
        case 3:
            return UIColor.yellowOrange_three
        case 4:
            return UIColor.yellow_four
        case 5:
            return UIColor.yellowGreen_five
        case 6:
            return UIColor.green_six
        case 7:
            return UIColor.teal_seven
        case 8:
            return UIColor.skyBlue_eight
        case 9:
            return UIColor.darkBlue_nine
        case 10:
            return UIColor.violet_ten
        case 11:
            return UIColor.redViolet_eleven
        case 12:
            return UIColor.pink_twelve
        default:
            return UIColor.gray
        }
    }
}
