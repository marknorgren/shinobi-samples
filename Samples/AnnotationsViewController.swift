//
//  AnnotationsViewController.swift
//  Samples
//
//  Created by Andrew Polkinghorn on 07/12/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import UIKit
import ShinobiCharts

struct Annotation {
    let x: String
    let y: Double
    let text: String
}

class AnnotationsViewController: UIViewController {
    
    // Annotation data to be displayed 
    let annotations = [Annotation(x: "14-09-2007", y: 250, text: "iPhone Released"),
                       Annotation(x: "09-09-2008", y: 300, text: "iPhone3G Released"),
                       Annotation(x: "09-09-2009", y: 280, text: "iPhone3GS Released"),
                       Annotation(x: "08-09-2010", y: 400, text: "iPhone4 Released"),
                       Annotation(x: "12-10-2011", y: 550, text: "iPhone4S Released"),
                       Annotation(x: "21-09-2012", y: 580, text: "iPhone5 Released")]
    
    // Data points for chart
    let dataPoints = JSONLoader.loadedDataPoints
    
    // Chart view used to display stock data
    let chart = ShinobiChart(frame: .zero)
    
    let dateFormat = "dd-MM-yyyy"
    
    var firstChartRender = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChart()
    }
    
    // Configure the chart view
    func setupChart() {
        chart.title = "Apple Stock Price"
        chart.backgroundColor = .clear
        
        // Add the axes
        let xAxis = SChartDateTimeAxis()
        xAxis.title = "Date"
        enablePanAndZoomForAxis(axis: xAxis)
        chart.xAxis = xAxis
        
        // Y axis is price of stock for given date
        let yAxis = SChartNumberAxis()
        yAxis.title = "Price (USD)"
        enablePanAndZoomForAxis(axis: yAxis)
        chart.yAxis = yAxis
        
        // To add annotaions, need to respond to some delgate method calls
        chart.delegate = self
        // This view controller will provide the data
        chart.datasource = self
        
        view.addSubview(chart)
        ViewConstrainer.layout(chart, in: view)
    }
    
    func enablePanAndZoomForAxis(axis: SChartAxis) {
        axis.enableMomentumPanning = true
        axis.enableMomentumZooming = true
        axis.enableGestureZooming = true
        axis.enableGesturePanning = true
    }
}

// MARK:- SChartDatasource Methods
extension AnnotationsViewController: SChartDatasource {
    
    func numberOfSeries(in chart: ShinobiChart) -> Int {
        return 1
    }
    
    func sChart(_ chart: ShinobiChart, seriesAt index: Int) -> SChartSeries {
        return SChartLineSeries()
    }
    
    func sChart(_ chart: ShinobiChart, numberOfDataPointsForSeriesAt seriesIndex: Int) -> Int {
        return dataPoints.count
    }
    
    func sChart(_ chart: ShinobiChart, dataPointAt dataIndex: Int, forSeriesAt seriesIndex: Int) -> SChartData {
        return dataPoints[dataIndex]
    }
}

// MARK:- SChartDelegate Methods
extension AnnotationsViewController: SChartDelegate {
    
    // On first render, add annotations to chart
    func sChartRenderFinished(_ chart: ShinobiChart) {
        if firstChartRender {
            firstChartRender = false
            
            // Add annotations to chart
            addAppleLogoToChart()
            addDateMarkerAnnotations()
        }
    }
    
    // Add Apple logo image to chart as a custom annotation view
    func addAppleLogoToChart() {
        
        // Create a zoomable annotation
        let annotation = SChartAnnotationZooming()
        annotation.xAxis = chart.xAxis
        annotation.yAxis = chart.yAxis
        
        // Pin logo corners
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        annotation.xValue = dateFormatter.date(from: "01-01-2009")
        annotation.yValue = 250
        annotation.xValueMax = dateFormatter.date(from: "01-01-2011")
        annotation.yValueMax = 550
        
        // Position below chart data
        annotation.position = .belowData
        
        // Load in image and add to annotation
        let logoView = UIImageView(image: UIImage(named: "Apple"))
        logoView.alpha = 0.2
        
        annotation.addSubview(logoView)
        
        // Finally, add annotation to chart
        chart.addAnnotation(annotation)
    }
    
    // Add annotations to chart corresponding to specific dates in stock price history
    func addDateMarkerAnnotations() {
        
        guard let xAxis = chart.xAxis,
            let yAxis = chart.yAxis else {
                print("Couldn't find axes to add annotations to.")
                return
        }
        
        // Rotate labels by 90 degress anti-clockwise
        let angleOfRotation = CGFloat(-M_PI/2)
        let rotationTransform = CGAffineTransform.identity.rotated(by: angleOfRotation)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        for dateAnnotation in annotations {
            
            guard let date = dateFormatter.date(from: dateAnnotation.x) else {
                continue
            }
            
            // Add a vertical line annotation
            let annotationLine = SChartAnnotation.verticalLine(atPosition: date, withXAxis: xAxis, andYAxis: yAxis, withWidth: 2, with: UIColor(white: 0.9, alpha: 1))
            chart.addAnnotation(annotationLine)
            
            let annotationColor = chart.plotAreaBackgroundColor?.withAlphaComponent(0.6) ?? .clear
            
            // Create annotation label
            let annotationLabel = SChartAnnotation(text: dateAnnotation.text, andFont: UIFont.systemFont(ofSize: 14), withXAxis: xAxis, andYAxis: yAxis, atXPosition: date, andYPosition: dateAnnotation.y, withTextColor: .black, withBackgroundColor: annotationColor)
            
            // Rotate the label
            annotationLabel.transform = rotationTransform
            
            // Position label above chart data
            annotationLabel.position = .aboveData
            
            // Add text annotation to chart
            chart.addAnnotation(annotationLabel)
        }
    }
}
