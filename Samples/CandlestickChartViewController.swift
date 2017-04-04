//
//  CandlestickChartViewController.swift
//  Samples
//
//  Created by Andrew Polkinghorn on 07/12/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import UIKit
import ShinobiCharts

class CandlestickChartViewController: UIViewController {
    
    let chart = ShinobiChart(frame: .zero)
    
    let dataPoints = JSONLoader.loadedMultiYDataPoints
    
    override var description: String {
        return "Candlestick Chart"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChart()
    }
    
    private func setupChart() {
        chart.backgroundColor = .white
        chart.clipsToBounds = false
        
        chart.title = "Apple Stock Price"
        chart.titleCentresOn = .chart
        
        // Add a pair of axes
        let xAxis = SChartDateTimeAxis()
        xAxis.title = "Date"
        xAxis.enableGesturePanning = true
        xAxis.enableGestureZooming = true
        chart.xAxis = xAxis
        
        let yAxis = SChartNumberAxis()
        yAxis.title = "Price (USD)"
        yAxis.enableGesturePanning = true
        yAxis.enableGestureZooming = true
        chart.yAxis = yAxis
        
        chart.datasource = self

        chart.crosshair = Crosshair(chart: chart)
        
        view.addSubview(chart)
        
        ViewConstrainer.layout(chart, in: view)
    }
}

extension CandlestickChartViewController: SChartDatasource {
    
    func numberOfSeries(in chart: ShinobiChart) -> Int {
        return 1
    }
    
    func sChart(_ chart: ShinobiChart, seriesAt index: Int) -> SChartSeries {
        let candleStickSeries = SChartCandlestickSeries()
        candleStickSeries.crosshairEnabled = true
        return candleStickSeries
    }
    
    func sChart(_ chart: ShinobiChart, numberOfDataPointsForSeriesAt seriesIndex: Int) -> Int {
        return dataPoints.count
    }
    
    func sChart(_ chart: ShinobiChart, dataPointAt dataIndex: Int, forSeriesAt seriesIndex: Int) -> SChartData {
        return dataPoints[dataIndex]
    }
}
