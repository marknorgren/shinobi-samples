//
//  ColumnChartViewController.swift
//  Samples
//
//  Created by Andrew Polkinghorn on 07/12/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import UIKit
import ShinobiCharts

class ColumnChartViewController: UIViewController {
    
    let chart = ShinobiChart(frame: .zero)
    
    // Grocery sales data array of dictionaries containing key value pairs matching grocery items to sales (in 1000s)
    let salesData: [[String : Double]] = [
        ["Broccoli" : 5.65, "Carrots" : 12.6, "Mushrooms" : 8.4], // 2016 sales
        ["Broccoli" : 4.35, "Carrots" : 13.2, "Mushrooms" : 4.6, "Okra" : 0.6] // 2017 sales
    ]

    override var description: String {
        return "Column Chart"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChart()
    }
    
    private func setupChart() {
        chart.backgroundColor = .white
        
        chart.title = "Grocery Sales Figures"
        
        // Create and add axes to chart
        let xAxis = SChartCategoryAxis()
        xAxis.style.interSeriesPadding = 0 // Don't add any padding between series columns with same x value
        chart.xAxis = xAxis
        
        let yAxis = SChartNumberAxis()
        yAxis.title = "Sales (1000s)"
        yAxis.rangePaddingHigh = 1
        chart.yAxis = yAxis
        
        // This view controller will provide data to the chart
        chart.datasource = self
        
        chart.legend.isHidden = false
        chart.legend.placement = .insidePlotArea
        
        view.addSubview(chart)
        
        ViewConstrainer.layout(chart, in: view)
    }
}

// MARK:- SChartDatasource Functions
extension ColumnChartViewController: SChartDatasource {
    
    // Two series of data (2016 and 2017 sales data)
    func numberOfSeries(in chart: ShinobiChart) -> Int {
        return 2
    }
    
    // Create column series objects for both sets of data and assign relevant title
    func sChart(_ chart: ShinobiChart, seriesAt index: Int) -> SChartSeries {
        let columnSeries = SChartColumnSeries()
        columnSeries.title = (index == 0 ? "2016" : "2017")
        return columnSeries
    }
    
    // Number of datapoints in series is equivalent to number of grocery items for year at seriesIndex
    func sChart(_ chart: ShinobiChart, numberOfDataPointsForSeriesAt seriesIndex: Int) -> Int {
        return salesData[seriesIndex].count
    }
    
    // Create data point objects
    func sChart(_ chart: ShinobiChart, dataPointAt dataIndex: Int, forSeriesAt seriesIndex: Int) -> SChartData {
        let dataPoint = SChartDataPoint()
        
        // Get array of keys (grocery names) for the series
        let allGroceriesInYear = Array(salesData[seriesIndex].keys)
        
        let groceryForDataPoint = allGroceriesInYear[dataIndex]
        
        // Set data point x and y values to grocery title and sales data
        dataPoint.xValue = groceryForDataPoint
        dataPoint.yValue = salesData[seriesIndex][groceryForDataPoint]
        
        return dataPoint
    }

}

