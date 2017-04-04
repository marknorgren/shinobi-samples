//
//  LabelledDataPointsViewController.swift
//  Samples
//
//  Created by Andrew Polkinghorn on 07/12/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import UIKit
import ShinobiCharts

class LabelledDataPointsViewController: UIViewController {

    let ukEconomyGrowthData: [(year: String, growthRate: Double)] = [
        ("2007", 2.586),
        ("2008", -0.467),
        ("2009", -4.192),
        ("2010", 1.54),
        ("2011", 1.972),
        ("2012", 1.179),
        ("2013", 2.16),
        ("2014", 2.853),
        ("2015", 2.329)]
    
    let chart = ShinobiChart(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChart()
    }
    
    func setupChart() {
        chart.backgroundColor = .clear
        chart.title = "UK Growth Rates"
        
        // Create chart axes
        let xAxis = SChartCategoryAxis()
        xAxis.title = "Year"
        chart.xAxis = xAxis
        
        let yAxis = SChartNumberAxis()
        yAxis.title = "Growth (%)"
        yAxis.rangePaddingLow = 1
        yAxis.rangePaddingHigh = 1
        chart.yAxis = yAxis
        
        // This controller will provide the data to the chart
        chart.datasource = self
        // To alter datapoint label styles we need to implement a delegate function
        chart.delegate = self
        
        view.addSubview(chart)
        
        ViewConstrainer.layout(chart, in: view)
    }
}

// MARK:- SChartDatasource Functions
extension LabelledDataPointsViewController: SChartDatasource {
    
    func numberOfSeries(in chart: ShinobiChart) -> Int {
        return 1
    }
    
    // Create column series object
    func sChart(_ chart: ShinobiChart, seriesAt index: Int) -> SChartSeries {
        let series = SChartColumnSeries()
        
        // Configure column colors for positive and negative Y values
        series.style().showAreaWithGradient = false
        series.style().areaColor = .shinobiGreen
        series.style().areaColorBelowBaseline = .shinobiRed
        
        // Display labels for each column
        series.style().dataPointLabelStyle.showLabels = true
        
        // Position labels slightly above data point on y axis
        series.style().dataPointLabelStyle.offsetFromDataPoint = CGPoint(x: 0, y: -15)
        
        // Label should contain just the y value of each data point
        series.style().dataPointLabelStyle.displayValues = .Y
        
        series.style().dataPointLabelStyle.textColor = .black
    
        return series
    }
    
    func sChart(_ chart: ShinobiChart, numberOfDataPointsForSeriesAt seriesIndex: Int) -> Int {
        return ukEconomyGrowthData.count
    }
    
    func sChart(_ chart: ShinobiChart, dataPointAt dataIndex: Int, forSeriesAt seriesIndex: Int) -> SChartData {
        let xValue = ukEconomyGrowthData[dataIndex].year
        let yValue = ukEconomyGrowthData[dataIndex].growthRate
        return SChartDataPoint(xValue:xValue, yValue:yValue)
    }
}

// MARK:- SChartDelegate Functions
extension LabelledDataPointsViewController: SChartDelegate {
    
    func sChart(_ chart: ShinobiChart, alter label: SChartDataPointLabel, for dataPoint: SChartDataPoint, in series: SChartSeries) {
        
        let rate = dataPoint.yValue as! Double
        // Want to alter text color based on positive or negative
        label.textColor = rate > 0 ? .shinobiGreen : .shinobiRed
        label.font = .boldSystemFont(ofSize: 18)
        
        let center = label.center
        // Resize label to fit increased font size
        label.sizeToFit()
        // Recenter label
        label.center = center
    }
}

