//
//  HistoryChartViewController.swift
//  HabitTracker
//
//  Created by David Sadler on 10/5/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit
import Charts

class HistoryChartViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    var habitHistory: [HabitHistory]?
    var datesAndFrequencies: [(Double,Double)] {
        get {
            guard let history = habitHistory else { return [] }
                return history.map { (historyPoint) -> (Double,Double) in
                    (historyPoint.recordingDate!.timeIntervalSince1970, Double(historyPoint.recordedFrequency))
                }
        }
    }
    var unit: String = "Times"
    var habitName: String = "Habit"
    
    // MARK: - Outlets
    
    @IBOutlet weak var chartsView: LineChartView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateGraph()
    }
    
    func updateGraph() {
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<datesAndFrequencies.count {
            let value = ChartDataEntry(x: Double(i), y: Double(datesAndFrequencies[i].1))
            lineChartEntry.append(value)
            let line1 = LineChartDataSet(entries: lineChartEntry, label: unit)
            line1.colors = [NSUIColor.blue]
            let data = LineChartData()
            data.addDataSet(line1)
            chartsView.data = data
            chartsView.chartDescription?.text = habitName
        }
    }
}
