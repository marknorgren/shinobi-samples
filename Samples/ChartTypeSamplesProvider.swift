//
//  ChartTypeSamplesProvider.swift
//  Samples
//
//  Created by Andrew Polkinghorn on 16/12/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import Foundation

struct ChartTypeSamplesProvider: SamplesProviding {
    
    let title = "Chart Types"
    
    let samples: [Sample] = {
        return [Sample(title: "Bubble Chart", type: BubbleChartViewController.self, isPremium: false),
                Sample(title: "Candlestick Chart", type: CandlestickChartViewController.self, isPremium: true),
                Sample(title: "Column Chart", type: ColumnChartViewController.self, isPremium: false),
                Sample(title: "Line Chart", type: LineChartViewController.self, isPremium: false),
                Sample(title: "Pie Chart", type: PieChartViewController.self, isPremium: false),
                Sample(title: "Polar Chart", type: PolarChartViewController.self, isPremium: false),
                Sample(title: "Radar Chart", type: RadarChartViewController.self, isPremium: false)]
    }()
}
