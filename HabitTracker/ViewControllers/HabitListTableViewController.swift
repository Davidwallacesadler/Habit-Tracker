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
    var goals: [Habit] {
        get {
            var goals = [Habit]()
            for habit in habitCollection {
                if habit.isNegativeHabit == false {
                    goals.append(habit)
                }
            }
            return goals
        }
    }
    var restrictions: [Habit] {
        get {
            var restrictions = [Habit]()
            for habit in habitCollection {
                if habit.isNegativeHabit {
                    restrictions.append(habit)
                }
            }
            return restrictions
        }
    }
    var headerTitles = ["Goals", "Restrictions"]
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        cleanOldHabitsIfNeeded()
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
        return headerTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 0 {
                return goals.count
            } else {
                return restrictions.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let habitCell = tableView.dequeueReusableCell(withIdentifier: "habitTableViewCell", for: indexPath) as? HabitTableViewCell else {
            print("Error Casting tableViewCell as HabitTableViewCell in cellForRowAt - Returning a blank UITableViewCell")
            return UITableViewCell()
        }
        switch indexPath.section {
        case 0:
            if goals.isEmpty {
                
            }

            let goal = goals[indexPath.row]
            setupTableViewCell(habitCell: habitCell, habit: goal)
        default:
            let restriction = restrictions[indexPath.row]
            setupTableViewCell(habitCell: habitCell, habit: restriction)
        }
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
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let sectionTitle = headerTitles[section]
//        return sectionTitle
//    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        let label = UILabel(frame: CGRect(x: 10,y: 6, width: tableView.frame.size.width, height: 18))
        label.text = headerTitles[section]
        label.textColor = .white
        label.font = UIFont(name: "Avenir-Medium", size: 18)
        if section == 0 {
            view.backgroundColor = #colorLiteral(red: 0.2852365154, green: 0.9340485873, blue: 0.2821596747, alpha: 0.5109696062)
        } else {
            view.backgroundColor = #colorLiteral(red: 1, green: 0.4188516695, blue: 0.7263484589, alpha: 0.5105950342)
        }
        view.addSubview(label)
        return view
    }
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // perform segue to counterVC
        switch indexPath.section {
        case 0 :
            selectedHabit = goals[indexPath.row]
        default:
            selectedHabit = restrictions[indexPath.row]
        }
        performSegue(withIdentifier: "toViewHabit", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editAction(atIndexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    // MARK: - Methods
    
    func editAction(atIndexPath: IndexPath) -> UIContextualAction {
        switch atIndexPath.section {
        case 0:
            selectedHabit = goals[atIndexPath.row]
        default:
            selectedHabit = restrictions[atIndexPath.row]
        }
        let action = UIContextualAction(style: .normal, title: "Edit") { (action,view,completion) in
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
