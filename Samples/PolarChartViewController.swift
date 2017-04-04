//
//  PolarChartViewController.swift
//  Samples
//
//  Created by Andrew Polkinghorn on 07/12/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import UIKit
import ShinobiCharts

class PolarChartViewController: UIViewController {

    let chart = ShinobiChart(frame: .zero)
    
    override var description: String {
        return "Polar Chart"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChart()
    }
    
    func setupChart() {
        chart.backgroundColor = .clear
        
        // Create the chart axes
        let xAxis = SChartNumberAxis()
        xAxis.majorTickFrequency = 45
        xAxis.style.majorGridLineStyle.showMajorGridLines = true
        chart.xAxis = xAxis
        
        let yAxis = SChartNumberAxis()
        yAxis.majorTickFrequency = 90
        yAxis.style.majorGridLineStyle.showMajorGridLines = true
        chart.yAxis = yAxis
        
        // This view controller will provide the data to the chart
        chart.datasource = self
        
        view.addSubview(chart)
        
        ViewConstrainer.layout(chart, in: view)
    }
}

// MARK:- SChartDatasource Functions
extension PolarChartViewController: SChartDatasource {
    
    func numberOfSeries(in chart: ShinobiChart) -> Int {
        return 1
    }
    
    // Create the radial line series object
    func sChart(_ chart: ShinobiChart, seriesAt index: Int) -> SChartSeries {
        let series = SChartRadialLineSeries()
        series.style().lineWidth = 5
        return series
    }
    
    func sChart(_ chart: ShinobiChart, numberOfDataPointsForSeriesAt seriesIndex: Int) -> Int {
        return 360
    }
    
    func sChart(_ chart: ShinobiChart, dataPointAt dataIndex: Int, forSeriesAt seriesIndex: Int) -> SChartData {
        
        // Create data point objects and configure x and y values
        let dataPoint = SChartDataPoint()
        
        dataPoint.xValue = dataIndex
        dataPoint.yValue = dataIndex
        
        return dataPoint
    }

}
