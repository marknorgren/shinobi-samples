//
//  DiscontinuousDateAxisViewController.swift
//  Samples
//
//  Created by Andrew Polkinghorn on 07/12/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import UIKit
import ShinobiCharts

class DiscontinuousDateAxisViewController: UIViewController {
    
    /// Chart to display stock data in (created using a storyboard)
    let chart = ShinobiChart(frame: .zero)
    
    let stockPriceData = JSONLoader.loadedDataPoints
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChart()
    }
    
    func setupChart() {
        chart.title = "Apple Stock Price"
        chart.backgroundColor = .clear
        
        // X Axis
        let xAxis = SChartDiscontinuousDateTimeAxis()
        xAxis.title = "Date"
        enablePanningAndZoomingOnAxis(axis: xAxis)
        
        /**
         Using 2nd January as an anchor, skip all dates on x axis that fall on weekends.
         
         Length of time to skip = 2 days (saturday and sunday)
         Repeat frequency = 1 week
         **/
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let anchorDate = dateFormatter.date(from: "02-01-2010")! // 01-01-2010 was a Saturday
        let weekends = SChartRepeatedTimePeriod(
            start: anchorDate,
            andLength: SChartDateFrequency(day: 2),
            andFrequency: SChartDateFrequency(weekOfMonth: 1)
        )
        xAxis.addExcludedRepeatedTimePeriod(weekends)
        chart.xAxis = xAxis
        
        // Y Axis
        let yAxis = SChartNumberAxis()
        yAxis.title = "Price (USD)"
        enablePanningAndZoomingOnAxis(axis: yAxis)
        chart.yAxis = yAxis
        
        // This view controller will provide data to the chart
        chart.datasource = self
        
        view.addSubview(chart)
        
        ViewConstrainer.layout(chart, in: view)
    }
    
    func enablePanningAndZoomingOnAxis(axis: SChartAxis) {
        axis.enableGesturePanning = true
        axis.enableGestureZooming = true
    }
}

// MARK:- SChartDatasource Methods
extension DiscontinuousDateAxisViewController: SChartDatasource {
    
    // One set of data (Apple Stock Prices)
    func numberOfSeries(in chart: ShinobiChart) -> Int {
        return 1
    }
    
    // Create line series object
    func sChart(_ chart: ShinobiChart, seriesAt index: Int) -> SChartSeries {
        return SChartLineSeries()
    }
    
    func sChart(_ chart: ShinobiChart, numberOfDataPointsForSeriesAt seriesIndex: Int) -> Int {
        return stockPriceData.count
    }
    
    func sChart(_ chart: ShinobiChart, dataPointAt dataIndex: Int, forSeriesAt seriesIndex: Int) -> SChartData {
        return stockPriceData[dataIndex]
    }
}
