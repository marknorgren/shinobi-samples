//
//  LineChartViewController.swift
//  Samples
//
//  Created by Andrew Polkinghorn on 07/12/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import Foundation

import ShinobiCharts

class LineChartViewController: UIViewController {
    
    let chart = ShinobiChart(frame: .zero)
    
    override var description: String {
        return "Line Chart"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChart()
    }
    
    private func setupChart() {        
        chart.backgroundColor = .clear
        chart.clipsToBounds = false
        chart.datasource = self

        chart.crosshair = Crosshair(chart: chart)
        
        // Create Axes
        let xAxis = SChartNumberAxis()
        enableInteraction(to: xAxis)
        addRangePadding(to: xAxis)
        chart.xAxis = xAxis
        
        let yAxis = SChartNumberAxis()
        enableInteraction(to: yAxis)
        addRangePadding(to: yAxis)
        chart.yAxis = yAxis
        
        // Display legend
        chart.legend.isHidden = false
        chart.legend.placement = .insidePlotArea
        
        view.addSubview(chart)
        
        ViewConstrainer.layout(chart, in: view)
    }
    
    private func addRangePadding(to axis: SChartAxis){
        axis.rangePaddingHigh = 0.1
        axis.rangePaddingLow = 0.05
    }
    
    private func enableInteraction(to axis: SChartAxis) {
        axis.enableGesturePanning = true
        axis.enableGestureZooming = true
        axis.enableMomentumPanning = true
        axis.enableMomentumZooming = true
    }
}

extension LineChartViewController: SChartDatasource {

    func numberOfSeries(in chart: ShinobiChart) -> Int {
        return 2
    }
    
    func sChart(_ chart: ShinobiChart, seriesAt index: Int) -> SChartSeries {
        let lineSeries = SChartLineSeries()
        
        if index == 0 {
            lineSeries.title = "y = cos(x)"
            lineSeries.style().lineColor = .shinobiRed

        } else {
            lineSeries.title = "y = sin(x)"
            lineSeries.style().lineColor = .shinobiGreen
        }
        
        lineSeries.style().lineWidth = 8
        lineSeries.crosshairEnabled = true
        
        
        return lineSeries
    }
    
    func sChart(_ chart: ShinobiChart, numberOfDataPointsForSeriesAt seriesIndex: Int) -> Int {
        return 120
    }
    
    func sChart(_ chart: ShinobiChart, dataPointAt dataIndex: Int, forSeriesAt seriesIndex: Int) -> SChartData {
        let datapoint = SChartDataPoint()
        
        // Both functions share the same x-values
        let xValue = Double(dataIndex) / 10.0
        datapoint.xValue = xValue
        
        // Compute the y-value for each series
        if seriesIndex == 0 {
            datapoint.yValue = cos(xValue)
        } else {
            datapoint.yValue = sin(xValue)
        }
        
        return datapoint
    }
}
