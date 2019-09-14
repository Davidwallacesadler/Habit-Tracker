//
//  HistoryTableViewController.swift
//  Habit Tracker
//
//  Created by David Sadler on 9/7/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    var habit: Habit?
    var habitHistory: [HabitHistory] {
        get {
            guard let history = habit?.history?.array as? [HabitHistory] else { return [] }
            return history
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        let bounds = self.view.bounds
        let imageView = UIImageView(frame: bounds)
        imageView.image = UIImage.init(named: "historyBackground")
        tableView.backgroundView = imageView
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return habitHistory.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyTableViewCell", for: indexPath)
        let historyPoint = habitHistory[indexPath.row]
        guard let recordingDate = historyPoint.recordingDate, let selectedHabit = habit else { return UITableViewCell() }
        let recordingDateText = recordingDate.stringValueWithoutTime()
        cell.textLabel?.text = "\(recordingDateText) : \(historyPoint.recordedFrequency) out of \( selectedHabit.desiredFrequency)"
        cell.textLabel?.textColor = .white
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
