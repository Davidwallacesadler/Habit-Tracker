//
//  HabitTrackerViewController.swift
//  Habit Tracker
//
//  Created by David Sadler on 9/3/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit
class HabitTrackerViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    var habit: Habit? {
        didSet {
            let timesDone = Int(habit!.currentTimesDone)
            count = timesDone
            initialCount = timesDone
        }
    }
    var initialCount: Int?
    var count: Int?
    var lastTimeCountChanged: Date?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    override func viewDidLayoutSubviews() {
        let background = UIImage(named: "trackerBackground")
        backgroundImageView.image = background
        backgroundImageView.contentMode = .scaleToFill
        ViewHelper.roundCornersOf(viewLayer: habitPhotoImageView.layer, withRoundingCoefficient: 38.0)
        ViewHelper.roundCornersOf(viewLayer: plusButton.layer, withRoundingCoefficient: 10.0)
        ViewHelper.roundCornersOf(viewLayer: minusButton.layer, withRoundingCoefficient: 10.0)
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var habitPhotoImageView: UIImageView!
    @IBOutlet weak var inentionLabel: UILabel!
    @IBOutlet weak var userIntentionLabel: UILabel!
    @IBOutlet weak var currentCountLabel: UILabel!
    @IBOutlet weak var desiredFrequencyLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    // MARK: - Actions

    @IBAction func minusButtonTapped(_ sender: Any) {
        guard let currentCount = count else { return }
        if currentCount > 0 {
            count = currentCount - 1
        }
        currentCountLabel.text = "\(count!)"
        lastTimeCountChanged = Date()
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        guard let currentCount = count else { return }
        count = currentCount + 1
        currentCountLabel.text = "\(count!)"
        lastTimeCountChanged = Date()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        guard let initial = initialCount, let current = count else { return }
        if current != initial {
            save()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func historyButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toShowHistory", sender: self)
    }
    
    // MARK: - Methods
    
    func updateViews() {
        guard let selectedHabit = habit else { return }
        desiredFrequencyLabel.text = "\(selectedHabit.desiredFrequency)"
        currentCountLabel.text = "\(selectedHabit.currentTimesDone)"
        userIntentionLabel.text = selectedHabit.userIntention
        habitPhotoImageView.image = selectedHabit.photo
        lastTimeCountChanged = selectedHabit.lastUpdatedDate
    }
    
    private func save() {
        guard let selectedHabit = habit, let currentCount = count, let lastChangeDate = lastTimeCountChanged, let lastZeroCountDate = selectedHabit.lastTimeCountWasZero else { return }
        if DateHelper.shared.areTwoDatesOnDiffernetDays(dateOne: lastChangeDate, dateTwo: lastZeroCountDate) {
            selectedHabit.lastUpdatedDate = lastZeroCountDate
        } else {
            selectedHabit.lastUpdatedDate = lastChangeDate
        }
        HabitController.shared.newCurrentTimesDoneFor(habit: selectedHabit, newCount: currentCount)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowHistory" {
            guard let detailVC = segue.destination as? HistoryTableViewController else { return }
            detailVC.habit = habit
            detailVC.navigationItem.title = habit?.name
        }
    }
    
    
}
