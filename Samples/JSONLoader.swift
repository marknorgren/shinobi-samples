//
//  JSONLoader.swift
//  Samples
//
//  Created by Andrew Polkinghorn on 15/12/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import Foundation
import ShinobiCharts

private struct StockPrice {
    let date: Date
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Double
}

struct JSONLoader {
    
    static var loadedMultiYDataPoints: [SChartMultiYDataPoint] {
        let stockPrices = JSONLoader.loadedAppleStockPrices
        
        var dataPoints = [SChartMultiYDataPoint]()
        for stockPrice in stockPrices {
            
            let dataPoint = SChartMultiYDataPoint()
            dataPoint.xValue = stockPrice.date
            
            let yValues: NSMutableDictionary = [SChartCandlestickKeyOpen : stockPrice.open,
                                                SChartCandlestickKeyHigh : stockPrice.high,
                                                SChartCandlestickKeyLow : stockPrice.low,
                                                SChartCandlestickKeyClose : stockPrice.close]
            dataPoint.yValues = yValues
            dataPoints.append(dataPoint)
        }
        
        return dataPoints
    }
    
    static var loadedDataPoints: [SChartDataPoint] {
        let stockPrices = JSONLoader.loadedAppleStockPrices
        
        var dataPoints = [SChartDataPoint]()
        for stockPrice in stockPrices {
            dataPoints.append(SChartDataPoint(xValue: stockPrice.date, yValue: stockPrice.close))
        }
        
        return dataPoints
    }
    
    static var loadedVolumeDataPoints: [SChartDataPoint] {
        let stockPrices = JSONLoader.loadedAppleStockPrices
        
        var dataPoints = [SChartDataPoint]()
        for stockPrice in stockPrices {
            // Convert volume count to be in terms of millions
            let yValue = stockPrice.volume / 1000000
            dataPoints.append(SChartDataPoint(xValue: stockPrice.date, yValue: yValue))
        }
        
        return dataPoints
    }
    
    private static let loadedAppleStockPrices: [StockPrice] = {
        
        var stockPrices = [StockPrice]()
        
        let jsonData = data(fromFileNamed: "AppleStockPrices")
        
        for dict in jsonData {
            guard // Extract data from JSON
                let dateString = dict["date"] as? String,
                let open = dict["open"] as? Double,
                let high = dict["high"] as? Double,
                let low = dict["low"] as? Double,
                let close = dict["close"] as? Double,
                let volume = dict["volume"] as? Double
                else {
                    print("Malformed JSON data")
                    return []
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            if let date = dateFormatter.date(from: dateString) {
                stockPrices.append(StockPrice(date: date, open: open, high: high, low: low, close: close, volume: volume))
            }
        }
        return stockPrices
    }()
    
    // Loads file and parses JSON
    private static func data(fromFileNamed fileName: String) -> [[String : AnyObject]] {
        guard let
            filePath = Bundle.main.path(forResource: fileName, ofType: "json"),
            let jsonData = NSData(contentsOfFile: filePath),
            let json = try? JSONSerialization.jsonObject(
                with: jsonData as Data,
                options: JSONSerialization.ReadingOptions.allowFragments
                ) as! [[String : AnyObject]]
            else {
                print("Problem loading JSON file.")
                return []
        }
        
        return json
    }
}
