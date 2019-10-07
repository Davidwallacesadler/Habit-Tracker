//
//  HistoryTableViewController.swift
//  Habit Tracker
//
//  Created by David Sadler on 9/7/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    // MARK: - Internal Properties
    
    let formatter = DateFormatter()
    var habit: Habit?
    
    // MARK: - Computed Properties
    
    var habitHistory: [HabitHistory] {
        get {
            guard var history = habit?.history?.array as? [HabitHistory] else { return [] }
            history.sort {one,two in {
                one.recordingDate! > two.recordingDate!
                }()
            }
            return history
        }
    }
    var historyGroupedByMonth: [Date: [HabitHistory]] {
        get {
            return createHistoryGroupings()
        }
    }
    var groupingKeys: [Date] {
        get {
            var grouping = [Date]()
            for key in historyGroupedByMonth.keys {
                grouping.append(key)
            }
            return grouping.sorted(by: >)
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        let bounds = self.view.bounds
        let imageView = UIImageView(frame: bounds)
        imageView.image = UIImage.init(named: "historyBackground")
        tableView.backgroundView = imageView
    }

    // MARK: - TableView Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return groupingKeys.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let firstOfTheMonth = groupingKeys[section]
        let monthAndYear = firstOfTheMonth.monthAndYear()
        return monthAndYear
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let weekKey = groupingKeys[section]
        guard let historyGroupingCount = historyGroupedByMonth[weekKey]?.count else { return 1 }
        return historyGroupingCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyTableViewCell", for: indexPath)
        let weekKey = groupingKeys[indexPath.section]
        if let habitHistoryGrouping = historyGroupedByMonth[weekKey] {
            let historyPoint = habitHistoryGrouping[indexPath.row]
            if let recordingDate = historyPoint.recordingDate, let selectedHabit = habit {
                let recordingDateWeekday = recordingDate.weekDay()
                formatter.dateStyle = .short
                let recordingDate = formatter.string(from: recordingDate)
                cell.textLabel?.text = "\(recordingDateWeekday), \(recordingDate) : \(historyPoint.recordedFrequency) out of \(selectedHabit.desiredFrequency) \(selectedHabit.unitOfCount!.pluralize())"
                cell.textLabel?.textColor = .white
            }
        }
        return cell
    }
    
    private func createHistoryGroupings() -> [Date: [HabitHistory]] {
        let grouping = habitHistory.groupedBy(dateComponents: [.year,.month])
        return grouping
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowCharts" {
            guard let destinationVC = segue.destination as? HistoryChartViewController else { return }
            destinationVC.habitHistory = habitHistory
            destinationVC.unit = (habit?.unitOfCount?.pluralize())!
            destinationVC.habitName = (habit?.name)!
        }
    }
}
