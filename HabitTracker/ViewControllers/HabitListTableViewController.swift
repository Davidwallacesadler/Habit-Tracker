//
//  HabitListTableViewController.swift
//  Habit Tracker
//
//  Created by David Sadler on 9/3/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class HabitListTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var habitCollection: [Habit] {
        get {
            return HabitController.shared.habits
        }
    }
    var selectedHabit: Habit?
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        cleanOldHabitsIfNeeded()
        registerCustomCells()
    }
    
    override func viewDidLayoutSubviews() {
        let bounds = self.view.bounds
        let imageView = UIImageView(frame: bounds)
        imageView.image = UIImage.init(named: "tableViewBackground")
        tableView.backgroundView = imageView
    }
    // MARK: - Actions
    
    @IBAction func filterButtonPressed(_ sender: Any) {
    }
    
    // MARK: - TableView DataSource Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habitCollection.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let habitCell = tableView.dequeueReusableCell(withIdentifier: "habitTableViewCell", for: indexPath) as? HabitTableViewCell else {
            print("Error Casting tableViewCell as HabitTableViewCell in cellForRowAt - Returning a blank UITableViewCell")
            return UITableViewCell()
        }
        let habitForCell = habitCollection[indexPath.row]
        setupTableViewCell(habitCell: habitCell, habit: habitForCell)
        return habitCell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let selectedHabit = habitCollection[indexPath.row]
            HabitController.shared.deleteHabit(habit: selectedHabit)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // perform segue to counterVC
        selectedHabit = habitCollection[indexPath.row]
        performSegue(withIdentifier: "toViewHabit", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editAction(atIndexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    // MARK: - Methods
    
    func editAction(atIndexPath: IndexPath) -> UIContextualAction {
        let habit = habitCollection[atIndexPath.row]
        let action = UIContextualAction(style: .normal, title: "Edit") { (action,view,completion) in
            self.selectedHabit = habit
            self.performSegue(withIdentifier: "toEditHabit", sender: self)
            completion(true)
        }
        action.backgroundColor = .green_six
        return action
    }
    
    func cleanOldHabitsIfNeeded() {
        for habit in habitCollection {
            #warning("Want to create habit history for every day this hasn't been used? with count of 0 and the day they missed -- could be truely helpful for someone that is trying to stop a habit")
            // IDEA: Check if the amount of zero days is over say 5 days or so -- then create a range -- and just append onto the string for now -- i.e (lastZeroDate) - (dayBeforeThisNextUpdate): 0 out of 8
            if DateHelper.shared.isTargetDateMoreThanADayAwayFromToday(givenTargetDate: habit.lastUpdatedDate!) {
                // find how many days there are between today and the last updated date
                HabitHistoryController.shared.createHistoryFor(habit: habit)
                HabitController.shared.resetHabitCount(habit: habit)
                tableView.reloadData()
            }
        }
    }
    
    private func setupTableViewCell(habitCell: HabitTableViewCell,habit: Habit) {
        habitCell.habitColorView.backgroundColor = ColorHelper.colorFrom(colorNumber: habit.colorId)
        habitCell.habtNameLabel.text = habit.name
        guard var countUnits = habit.unitOfCount else { return }
        if habit.currentTimesDone > 1 || habit.currentTimesDone == 0 {
            countUnits = countUnits.pluralize()
        }
        habitCell.habitProgressLabel.text = "\(habit.currentTimesDone) \(countUnits) out of \(habit.desiredFrequency) Today"
        
        if habit.isNegativeHabit {
            habitCell.habitProgressLabel.textColor = UIColor.redOrange_two
            if habit.currentTimesDone >= habit.desiredFrequency {
                #warning("show some negative icon")
                habitCell.habitProgressLabel.textColor = UIColor.red
            }
        } else {
            habitCell.habitProgressLabel.textColor = UIColor.green_six
            if habit.currentTimesDone >= habit.desiredFrequency {
                #warning("show a star icon or something")
                habitCell.habitProgressLabel.textColor = UIColor.green
            }
        }
        habitCell.habitPhotoImageView?.image = habit.photo
//        habitCell.habitPhotoImageView?.contentMode = .scaleAspectFit
        ViewHelper.roundCornersOf(viewLayer: habitCell.habitPhotoImageView.layer, withRoundingCoefficient: 35.0)
        let bounds = habitCell.bounds
        let backgroundView = UIView(frame: bounds)
        backgroundView.tintColor = .clear
        habitCell.backgroundView = backgroundView
        habitCell.backgroundColor = .clear
        let borderViewLayer = habitCell.borderView.layer
        borderViewLayer.cornerRadius = 10.0
        borderViewLayer.borderWidth = 1.0
        borderViewLayer.borderColor = UIColor.white.cgColor
        borderViewLayer.masksToBounds = true
        habitCell.selectionStyle = .none
    }
    
    private func registerCustomCells() {
       tableView.register(UINib(nibName: "HabitTableViewCell", bundle: nil), forCellReuseIdentifier: "habitTableViewCell")
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewHabit" {
            guard let trackerVC = segue.destination as? HabitTrackerViewController, let habit = selectedHabit else { return }
            trackerVC.habit = habit
            trackerVC.navigationItem.title = habit.name!
        } else if segue.identifier == "toEditHabit" {
            guard let detailVC = segue.destination as? HabitCreationTableViewController, let habit = selectedHabit else { return }
            detailVC.habit = habit
            detailVC.navigationItem.title = habit.name!
        }

    }
}
