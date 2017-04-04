//
//  ChartFeatureSamplesProvider.swift
//  Samples
//
//  Created by Andrew Polkinghorn on 16/12/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import Foundation

struct ChartFeatureSamplesProvider: SamplesProviding {
    
    let title = "Features"
    
    let samples: [Sample] = {
        return [Sample(title: "Annotations", type: AnnotationsViewController.self, isPremium: true),
                Sample(title: "Discontinuous Date Axis", type: DiscontinuousDateAxisViewController.self, isPremium: true),
                Sample(title: "Labelled Data Points", type: LabelledDataPointsViewController.self, isPremium: false),
                Sample(title: "Multiple Y-Axes", type: MultiAxesViewController.self, isPremium: true),
                Sample(title: "Streaming", type: StreamingViewController.self, isPremium: false)]
    }()
}
