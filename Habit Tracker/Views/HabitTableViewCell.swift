//
//  HabitTableViewCell.swift
//  Habit Tracker
//
//  Created by David Sadler on 9/3/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class HabitTableViewCell: UITableViewCell {
    
    // MARK: - View Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var habitColorView: UIView!
    @IBOutlet weak var habitPhotoImageView: UIImageView!
    @IBOutlet weak var habitProgressLabel: UILabel!
    @IBOutlet weak var habtNameLabel: UILabel!
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
