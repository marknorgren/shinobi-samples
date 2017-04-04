//
//  RadarChartViewController.swift
//  Samples
//
//  Created by Andrew Polkinghorn on 07/12/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import UIKit
import ShinobiCharts

class RadarChartViewController: UIViewController {
    
    // Dummy temperature data
    let minTemps: [String : [Double]] = [
        "San Francisco" : [8.1, 9.1, 9.2, 9.5, 11.0, 12.2, 12.5, 13.1, 13.0, 12.1, 10.3, 8.4],
        "Newcastle upon Tyne" : [2.2, 2.2, 3.3, 4.8, 7.2, 10.0, 12.3, 12.3, 10.4, 7.7, 4.9, 2.5]
    ]
    
    let chart = ShinobiChart(frame: .zero)
    
    override var description: String {
        return "Radar Chart"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChart()
    }
    
    func setupChart() {
        chart.backgroundColor = .clear
        
        chart.title = "Average Minimum Temperatures by Month"
        
        chart.titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        
        // Create chart axes
        let xAxis = SChartCategoryAxis()
        xAxis.style.majorGridLineStyle.lineRenderMode = .linear
        xAxis.style.majorGridLineStyle.showMajorGridLines = true
        xAxis.style.majorGridLineStyle.lineColor = .lightGray
        chart.xAxis = xAxis
        
        // Add a range to the y axis
        let yAxis = SChartNumberAxis(range: SChartNumberRange(minimum: 0, maximum: 15))
        yAxis.style.majorGridLineStyle.lineRenderMode = .linear
        yAxis.style.majorGridLineStyle.showMajorGridLines = true
        yAxis.style.majorGridLineStyle.lineColor = .lightGray
        yAxis.title = "Temp (°C)"
        chart.yAxis = yAxis
        
        // Show legend and position along bottom
        chart.legend.isHidden = false
        chart.legend.position = .bottomMiddle
        
        // This view controller will provide the chart with data
        chart.datasource = self
        
        view.addSubview(chart)
        
        ViewConstrainer.layout(chart, in: view)
    }
    
    // Return a month as a string given a data point index (0 = January, 1 = February, e.t.c)
    func monthString(index: Int) -> String {
        let formatter = DateFormatter()
        let monthString = formatter.monthSymbols[index]
        
        return monthString
    }
}

// MARK:- SChartDatasource Functions
extension RadarChartViewController: SChartDatasource {
    
    func numberOfSeries(in chart: ShinobiChart) -> Int {
        return minTemps.count
    }
    
    // Create radar series object
    func sChart(_ chart: ShinobiChart, seriesAt index: Int) -> SChartSeries {
        let radarSeries = SChartRadialLineSeries()
        
        // Set title of series to display in legend
        radarSeries.title = Array(minTemps.keys)[index]
        
        // Increase the line width
        radarSeries.style().lineWidth = 3
        
        // Join up first and last points
        radarSeries.pointsWrapAround = true
        
        return radarSeries
    }
    
    func sChart(_ chart: ShinobiChart, numberOfDataPointsForSeriesAt seriesIndex: Int) -> Int {
         // We have data points for each month of the year
        return 12
    }
    
    func sChart(_ chart: ShinobiChart, dataPointAt dataIndex: Int, forSeriesAt seriesIndex: Int) -> SChartData {
        
        // City that series is showing temperature data for
        let cityKey = Array(minTemps.keys)[seriesIndex]

        guard let tempData = minTemps[cityKey]
            else {
                fatalError("Missing data.")
        }
        
        // Create data point
        let dataPoint = SChartDataPoint()
        
        // X value is month title
        let monthString = self.monthString(index: dataIndex)
        dataPoint.xValue = monthString
        
        // Y axis is average minimum temperature for month
        dataPoint.yValue = tempData[dataIndex]
        
        return dataPoint
    }
}
