//
//  StreamingViewController.swift
//  Samples
//
//  Created by Andrew Polkinghorn on 07/12/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import UIKit
import ShinobiCharts

class StreamingViewController: UIViewController {

    let chart = ShinobiChart(frame: .zero)
    
    override var description: String {
        return "Streaming"
    }
    
    // Store index to append a new data point
    var currentDataIndex: Int = 0
    
    // MutableArray to store SChartDataPoint objects to be drawn on chart
    var streamedData: [SChartDataPoint] = []
    
    // create the timer to update line series
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        setupChart()
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(StreamingViewController.updateLineSeries), userInfo: nil, repeats: true)
    }
    
    func setupChart() {
        chart.backgroundColor = .clear
        chart.clipsToBounds = false
        
        // Add x and y axis
        chart.xAxis = SChartNumberAxis()
        chart.yAxis = SChartNumberAxis()
        
        // This view controller will provide the data points to the chart
        chart.datasource = self
        
        // Add chart to the controller's view
        view.addSubview(chart)
        
        ViewConstrainer.layout(chart, in: view)
    }
    
    func loadData() {
        // Create initial data points
        let numberOfDataPoints = 360
        
        for index in 0..<numberOfDataPoints {
            let dataPointAtIndex = dataPointWithIndex(index)
            streamedData.append(dataPointAtIndex)
        }
        
        // update current index value so new items are appended to right side of chart
        currentDataIndex = streamedData.count
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer.invalidate()
    }
    
    // Add and remove SChartDataPoint objects
    func updateLineSeries() {
        
        // Remove leftmost data point from array
        streamedData.remove(at: 0)
        
        // Append new data point item
        let newDataPoint = dataPointWithIndex(currentDataIndex)
        streamedData.append(newDataPoint)
        
        // Increment the data index value for next time timer invokes this function
        currentDataIndex += 1
        
        // Notify chart we're removing an item and appending another
        chart.remove(numberOfDataPoints: 1, fromStartOfSeriesAtIndex: 0)
        chart.append(numberOfDataPoints: 1, toEndOfSeriesAtIndex: 0)
        
        // Finally, redraw the chart
        chart.redraw()
    }
    
    // Create a SChartDataPoint object and set x and y attributes
    func dataPointWithIndex(_ index: Int) -> SChartDataPoint {
        let dataPoint = SChartDataPoint()
        dataPoint.xValue = index
        dataPoint.yValue = sinOfValue(index)
        return dataPoint
    }
    
    // Given the x value, return y such that y = sin(x)
    func sinOfValue(_ value: Int) -> Double {
        let valueInRadians = Double(value) * (M_PI / 180.0)
        return sin(valueInRadians)
    }
}

// MARK: - SChartDatasource Functions
extension StreamingViewController: SChartDatasource {
    
    // We have one set of data to draw (sin curve)
    func numberOfSeries(in chart: ShinobiChart) -> Int {
        return 1
    }
    
    // Create line series chart
    func sChart(_ chart: ShinobiChart, seriesAt index: Int) -> SChartSeries {
        let lineSeries = SChartLineSeries()
        lineSeries.style().lineWidth = 2
        
        return lineSeries
    }
    
    // Number of data points is equal to the number of data point objects in the streamedData array
    func sChart(_ chart: ShinobiChart, numberOfDataPointsForSeriesAt seriesIndex: Int) -> Int {
        return streamedData.count
    }
    
    // Retrieve data point from streamedData array
    func sChart(_ chart: ShinobiChart, dataPointAt dataIndex: Int, forSeriesAt seriesIndex: Int) -> SChartData {
        return streamedData[dataIndex]
    }
}

