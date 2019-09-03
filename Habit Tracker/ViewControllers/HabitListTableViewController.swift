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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func filterButtonPressed(_ sender: Any) {
    }
    
    // MARK: - Table view data source

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
    
    private func setupTableViewCell(habitCell: HabitTableViewCell,habit: Habit) {
        habitCell.habitColorView.tintColor = ColorHelper.colorFrom(colorNumber: habit.colorId)
        habitCell.habtNameLabel.text = habit.name
        habitCell.habitProgressLabel.text = "\(habit.currentTimesDone) / \(habit.desiredFrequency) "
        if habit.isNegativeHabit {
            habitCell.habitProgressLabel.textColor = UIColor.redOrange_two
        } else {
            habitCell.habitProgressLabel.textColor = UIColor.green_six
        }
        habitCell.imageView?.image = habit.photo
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let selectedHabit = habitCollection[indexPath.row]
            HabitController.shared.deleteHabit(habit: selectedHabit)
            HabitHistoryController.shared.deleteAllHistoryForHabit(habit: selectedHabit)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // perform segue to counterVC
        selectedHabit = habitCollection[indexPath.row]
        performSegue(withIdentifier: "toViewHabit", sender: self)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toViewHabit" {
            
        }
    }

}
