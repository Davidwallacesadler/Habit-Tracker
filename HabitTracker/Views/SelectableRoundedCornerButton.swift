//
//  SelectableRoundedCornerButton.swift
//  HabitTracker
//
//  Created by David Sadler on 9/10/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class SelectableRoundedCornerButton: UIButton {
    
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton()
    }
    
    // MARK: - Properties
    
    var roundingCoeffiecient: Double = 5.0
    var borderWidth: Double = 5.0
    var borderColor: UIColor = .borderPartiallyClearBlack
    var currentlySelected: Bool = false {
        didSet {
           configureBorder()
        }
    }
    
    // MARK: - Methods
    
    func setupButton() {
        ViewHelper.roundCornersOf(viewLayer: self.layer, withRoundingCoefficient: 5.0)
    }
    func configureBorder() {
        if currentlySelected == false {
            ViewHelper.removeBorderFromButton(button: self)
        } else {
            ViewHelper.createABorderFor(viewLayer: self.layer, withRoundingCoefficient: roundingCoeffiecient, desiredColor: borderColor, borderWidth: borderWidth)
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
