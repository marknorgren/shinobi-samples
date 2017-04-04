//
//  MultiAxesViewController.swift
//  Samples
//
//  Created by Andrew Polkinghorn on 07/12/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import UIKit
import ShinobiCharts

class MultiAxesViewController: UIViewController {

    let chart = ShinobiChart(frame: .zero)
    
    // Data point mutable arrays
    let stockPriceDataPoints = JSONLoader.loadedDataPoints
    let volumeDataPoints = JSONLoader.loadedVolumeDataPoints
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChart()
    }
    
    func setupChart() {
        chart.title = "Apple Inc. (AAPL)"
        chart.backgroundColor = .clear
        
        // Chart Axes Configuration
        let xAxis: SChartDateTimeAxis
        
        // Configure date range to initially show
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let initialMinDate = dateFormatter.date(from: "01-01-2010"),
            let initialMaxDate = dateFormatter.date(from: "01-06-2010") {
            let dateRange = SChartDateRange(dateMinimum: initialMinDate, dateMaximum: initialMaxDate)
            xAxis = SChartDateTimeAxis(range: dateRange)
        } else {
            xAxis = SChartDateTimeAxis()
        }
        
        xAxis.title = "Date"
        enablePanningAndZoomingOnAxis(axis: xAxis)
        chart.xAxis = xAxis
        
        // Initially show range on y-axis between 150 and 300 USD
        let numberRange = SChartNumberRange(minimum: 150, maximum: 300)
        
        // Stock price y axis
        let stockPriceAxis = SChartNumberAxis(range: numberRange)
        stockPriceAxis.title = "Price (USD)"
        enablePanningAndZoomingOnAxis(axis: stockPriceAxis)
        chart.addYAxis(stockPriceAxis)
        
        // Secondary Y axis for volume data
        let volumeAxis = SChartNumberAxis()
        volumeAxis.title = "Volume"
        
        // Format label to hide decimal places and append 'M' units
        volumeAxis.labelFormatString = "%.0fM"
        
        // Render on right-hand side (reverse)
        volumeAxis.axisPosition = .reverse
        
        // Hide gridlines
        volumeAxis.style.majorGridLineStyle.showMajorGridLines = false
        
        // Add upper padding to make the volume chart occupy bottom half of the plot area
        volumeAxis.rangePaddingHigh = 100
        
        chart.addYAxis(volumeAxis)
        
        // This controller will provide the chart data
        chart.datasource = self
        // Designate this controller as the delegate to enable alteration of tick marks
        chart.delegate = self
        
        view.addSubview(chart)
        ViewConstrainer.layout(chart, in: view)
    }
    
    
    func enablePanningAndZoomingOnAxis(axis: SChartAxis) {
        axis.enableGesturePanning = true
        axis.enableGestureZooming = true
    }
}


// MARK:- SChartDatasource Methods
extension MultiAxesViewController: SChartDatasource {
    
    // As we have multiple y-axes, need to specify which the series each axis corresponds to
    func sChart(_ chart: ShinobiChart, yAxisForSeriesAt index: Int) -> SChartAxis? {
        return chart.allYAxes()[index] as SChartAxis
    }
    
    // Two sets of data (stock prices and volume)
    func numberOfSeries(in chart: ShinobiChart) -> Int {
        return 2
    }
    
    // Create series objects
    func sChart(_ chart: ShinobiChart, seriesAt index: Int) -> SChartSeries {
        return index == 0 ? SChartLineSeries() : SChartColumnSeries()
    }
    
    func sChart(_ chart: ShinobiChart, numberOfDataPointsForSeriesAt seriesIndex: Int) -> Int {
        return stockPriceDataPoints.count
    }
    
    func sChart(_ chart: ShinobiChart, dataPointAt dataIndex: Int, forSeriesAt seriesIndex: Int) -> SChartData {
        return seriesIndex == 0 ? stockPriceDataPoints[dataIndex] : volumeDataPoints[dataIndex]
    }
}

// MARK:- SChartDelegate Methods
extension MultiAxesViewController: SChartDelegate {
    
    // Hide tick marks with values above 100M
    func sChart(_ chart: ShinobiChart, alter tickMark: SChartTickMark, beforeAddingTo axis: SChartAxis) {
        if let volumeAxis = chart.allYAxes().last {
            if axis == volumeAxis {
                if tickMark.value > 100 {
                    if let view = tickMark.tickMarkView {
                        view.isHidden = true
                    }
                    if let label = tickMark.tickLabel {
                        label.text = ""
                    }
                }
            }
        }
    }
    
}
