//
//  ViewHelper.swift
//  HabitTracker
//
//  Created by David Sadler on 9/9/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import UIKit

struct ViewHelper {
    
    /// Rounds the corners of the CALayer of the desired view based on the rounding number passed in. The larger the number the more the corners are rounded.
    static func roundCornersOf(viewLayer: CALayer,withRoundingCoefficient rounding: Double) {
        viewLayer.cornerRadius = CGFloat(rounding)
        viewLayer.borderWidth = 1.0
        viewLayer.borderColor = UIColor.clear.cgColor
        viewLayer.masksToBounds = true
    }
    
    static func createABorderFor(viewLayer: CALayer,withRoundingCoefficient rounding: Double, desiredColor: UIColor, borderWidth: Double) {
        viewLayer.cornerRadius = CGFloat(rounding)
        viewLayer.borderWidth = CGFloat(borderWidth)
        viewLayer.borderColor = desiredColor.cgColor
        viewLayer.masksToBounds = true
    }
    
    static func removeBorderFromButton(button: UIButton) {
        button.layer.borderColor = UIColor.clear.cgColor
    }
    
}
