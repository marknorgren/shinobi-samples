//
//  BubbleChartViewController.swift
//  Samples
//
//  Created by Andrew Polkinghorn on 07/12/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import UIKit
import ShinobiCharts

class BubbleChartViewController: UIViewController {
    
    let chart = ShinobiChart(frame: .zero)
    
    // Store data points for chart
    var data: [SChartDataPoint] = []
    
    override var description: String {
        return "Bubble Chart"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChart()
        
        // Load chart data
        loadData()
        
        // Set this view controller as the provider of data to the chart
        chart.datasource = self
    }
    
    private func setupChart() {
        chart.backgroundColor = .white
        
        chart.title = "Project Commit Punchcard"
        chart.titleCentresOn = .chart
        
        // Axes creation
        let yAxis = SChartCategoryAxis()
        yAxis.title = "Day"
        yAxis.rangePaddingHigh = 0.5
        yAxis.rangePaddingLow = 0.5
        chart.yAxis = yAxis
        
        let xAxis = SChartNumberAxis()
        xAxis.title = "Hour"
        xAxis.rangePaddingHigh = 2
        xAxis.majorTickFrequency = 6
        chart.xAxis = xAxis
        
        view.addSubview(chart)
        
        ViewConstrainer.layout(chart, in: view)
    }
    
    // Load and parse contents of JSON file into an array of parsed key-value objects
    func JSONDataFromFile(fileName: String) -> [[String : AnyObject]] {
        guard let
            filePath = Bundle.main.path(forResource: fileName, ofType: "json"),
            let jsonData = NSData(contentsOfFile: filePath),
            let json = try? JSONSerialization.jsonObject(
                with: jsonData as Data,
                options: JSONSerialization.ReadingOptions.allowFragments
                ) as! [[String : AnyObject]]
            else {
                print("Problem loading JSON file.")
                return []
        }
        
        return json
    }
    
    // Loads contents of a JSON file into an array of data points
    func loadData() {
        
        // Iterate through hourly commit data loaded from punchcard.json file
        for commitInterval in JSONDataFromFile(fileName: "punchcard") {
            
            guard let
                numberOfCommits = commitInterval["commits"] as? Int,
                let hour = commitInterval["hour"],
                let day = commitInterval["day"]
                else {
                    print("Malformed JSON data")
                    return
            }
            
            // Create SChartBubbleDataPoint object and set x and y values
            let bubbleDataPoint = SChartBubbleDataPoint()
            bubbleDataPoint.xValue = hour
            bubbleDataPoint.yValue = day
            bubbleDataPoint.area = Double(numberOfCommits)
            
            // Finally, add new data point to array
            data.append(bubbleDataPoint)
        }
    }
}

// MARK:- SChartDatasource Functions
extension BubbleChartViewController: SChartDatasource {
    
    // We have one series of data (commit data)
    func numberOfSeries(in chart: ShinobiChart) -> Int {
        return 1
    }
    
    // Create bubble series object
    func sChart(_ chart: ShinobiChart, seriesAt index: Int) -> SChartSeries {
        let bubbleSeries = SChartBubbleSeries()
        bubbleSeries.style().pointStyle().color = .shinobiBlue
        
        // Configure maximum value's bubble diameter
        bubbleSeries.biggestBubbleDiameterForAutoScaling = 50
        
        return bubbleSeries
    }
    
    // Number of data points is equal to length of commit data array loaded from the JSON file
    func sChart(_ chart: ShinobiChart, numberOfDataPointsForSeriesAt seriesIndex: Int) -> Int {
        return data.count
    }
    
    // Retrieve SChartDataPoint from data array
    func sChart(_ chart: ShinobiChart, dataPointAt dataIndex: Int, forSeriesAt seriesIndex: Int) -> SChartData {
        return data[dataIndex]
    }
}

