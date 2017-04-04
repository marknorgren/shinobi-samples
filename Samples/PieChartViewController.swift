//
//  PieChartViewController.swift
//  Samples
//
//  Created by Andrew Polkinghorn on 07/12/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import UIKit
import ShinobiCharts

class PieChartViewController: UIViewController {
    
    let chart = ShinobiChart(frame: .zero)
    
    let drinkPopularityData: [String: NSNumber] = ["Coke" : 20.5, "Coffee" : 39.5, "Tea" : 30.5, "Water" : 5, "Other" : 4.5]
    
    var selectedDrinksTotalPopularity = 0.00
    
    // Label to display combined total of all selected segments
    let selectedDrinksLabel = UILabel(frame: .zero)
    
    override var description: String {
        return "Pie Chart"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChart()
        
        setupLabel()
    }
    
    func setupChart() {
        chart.backgroundColor = .clear
        
        chart.title = "Most Popular Drinks (%)"
        chart.titleCentresOn = .chart
        
        // Show the legend and position along the right edge in the middle of the screen
        chart.legend.isHidden = false
        chart.legend.position = .middleRight
        
        // This view controller will provide the data points to the chart
        chart.datasource = self
        
        // Set this controller to be the chart's delegate in order to respond to touches on a pie segment
        chart.delegate = self
        
        view.addSubview(chart)
        
        ViewConstrainer.layout(chart, in: view)
    }
    
    func setupLabel() {
        view.addSubview(selectedDrinksLabel)
        
        selectedDrinksLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedDrinksLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        selectedDrinksLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        selectedDrinksLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        selectedDrinksLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        selectedDrinksLabel.text = "Selected Drinks' Popularity: 0.00%"
    }
}

// MARK:- SChartDatasource Functions
extension PieChartViewController: SChartDatasource {
    
    // Only have one series of data to display (drink popularity)
    func numberOfSeries(in chart: ShinobiChart) -> Int {
        return 1
    }
    
    // Create pie series object
    func sChart(_ chart: ShinobiChart, seriesAt index: Int) -> SChartSeries {
        let pieSeries = SChartPieSeries()
        
        pieSeries.style().labelBackgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        // Configure some basic styles when a segment is selected
        pieSeries.selectedStyle().protrusion = 30
        pieSeries.selectionAnimationDuration = 0.4
        pieSeries.selectedPosition = 0
        
        return pieSeries
    }
    
    func sChart(_ chart: ShinobiChart, numberOfDataPointsForSeriesAt seriesIndex: Int) -> Int {
        return drinkPopularityData.count
    }
    
    // Create data points to represent each segment of the pie chart
    func sChart(_ chart: ShinobiChart, dataPointAt dataIndex: Int, forSeriesAt seriesIndex: Int) -> SChartData {
        let dataPoint = SChartRadialDataPoint()
        
        let drinkTitle = Array(drinkPopularityData.keys)[dataIndex]
        
        // Used to identify segment category in the legend
        dataPoint.name = drinkTitle
        // Value segment represents out of total
        dataPoint.value = drinkPopularityData[drinkTitle]
        
        return dataPoint
    }
}

// MARK:- SChartDelegate Functions
extension PieChartViewController: SChartDelegate {
    
    // Display combined popularity of all selected segments
    func sChart(_ chart: ShinobiChart, toggledSelectionFor dataPoint: SChartRadialDataPoint, in series: SChartRadialSeries, at pixelPoint: CGPoint) {
        
        let yVal = dataPoint.yValue as! Double
        
        if series.selectedDataPoints.contains(dataPoint) {
            selectedDrinksTotalPopularity += yVal
        } else {
            selectedDrinksTotalPopularity -= yVal
        }
        
        // Convert popularity total to string and update label text
        let popularityString = String(format:"%.2f", selectedDrinksTotalPopularity)
        selectedDrinksLabel.text = "Selected Drinks' Popularity: " + popularityString + "%"
    }
    
}
