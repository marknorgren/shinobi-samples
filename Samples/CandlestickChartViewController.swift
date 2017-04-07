//
//  CandlestickChartViewController.swift
//  Samples
//
//  Created by Andrew Polkinghorn on 07/12/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import UIKit
import ShinobiCharts

class CandlestickChartViewController: UIViewController, SChartDelegate {
    
    let chart = ShinobiChart(frame: .zero)
    
    var dataPoints = JSONLoader.loadedMultiYDataPoints
    
    override var description: String {
        return "Candlestick Chart"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupChart()

        startTimer()

    }

    var timer: DispatchSourceTimer?

    private func startTimer() {
        let queue = DispatchQueue(label: "com.firm.app.timer", attributes: .concurrent)

        timer?.cancel()        // cancel previous timer if any

        timer = DispatchSource.makeTimerSource(queue: queue)

        timer?.scheduleRepeating(deadline: .now(), interval: .seconds(5), leeway: .seconds(1))
        timer?.setEventHandler { [weak self] in // `[weak self]` only needed if you reference `self` in this closure and you want to prevent strong reference cycle
            print("reload\n")
            DispatchQueue.main.async {
                //self?.dataPoints.append((self?.newDataPoint())!)
                self?.chart.reloadData()
                self?.chart.redraw()
            }

        }
        
        timer?.resume()
    }

    func newDataPoint() -> SChartMultiYDataPoint {
        let dataPoint = SChartMultiYDataPoint()
        dataPoint.xValue = "2013-01-29"

        let yValues: NSMutableDictionary = [SChartCandlestickKeyOpen : 123,
                                            SChartCandlestickKeyHigh : 125,
                                            SChartCandlestickKeyLow : 120,
                                            SChartCandlestickKeyClose : 111]
        dataPoint.yValues = yValues
        //dataPoints.append(dataPoint)
        return dataPoint
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
        chart.delegate = self

        chart.crosshair = Crosshair(chart: chart)
//        chart.crosshair = SChartCrosshair(chart: chart)
//        chart.crosshair?.style.lineColor = .black

        view.addSubview(chart)
        
        ViewConstrainer.layout(chart, in: view)
    }

    
    public func sChartRenderFinished(_ chart: ShinobiChart) {
        //self.reorderSubviews(chart: chart)
//        guard let crosshair = chart.crosshair as? Crosshair  else {
//            return
//        }
//        crosshair.updateCrosshair()
        guard let crosshair = chart.crosshair as? Crosshair else {
            return
        }
        crosshair.updateCrosshair(in: chart)
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
