//
//  ClearAndBoldTableViewHeaderFooterView.swift
//  HabitTracker
//
//  Created by David Sadler on 9/14/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class ClearAndBoldTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupHeaderFooterView()
    }
    
    func setupHeaderFooterView() {
        let background = UIView(frame: self.bounds)
        background.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.09613120719)
        self.backgroundView = background
        self.textLabel?.textColor = .white
    }
}
