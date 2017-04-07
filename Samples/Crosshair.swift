//
//  Crosshair.swift
//  shinobi-swift-test
//
//  Created by Mark Norgren on 4/4/17.
//  Copyright © 2017 Mark Norgren. All rights reserved.
//

import Foundation
import ShinobiCharts

class Crosshair: SChartCrosshair {
    var parentChart: ShinobiChart?
    override init(chart parentChart: ShinobiChart) {
        super.init(chart: parentChart)
        self.parentChart = parentChart
        self.lineDrawer = SChartTargetLineDrawer()
        self.style = crosshairStyle()
    }

    func crosshairStyle() -> SChartCrosshairStyle {
        let crosshairStyle = SChartCrosshairStyle()

        crosshairStyle.lineColor = UIColor.black
        crosshairStyle.lineWidth = 2.0
        crosshairStyle.defaultLabelBackgroundColor = .white

        return crosshairStyle
    }

    var crosshairPoint: CGPoint?
    override func move(to pointInChart: CGPoint, in chart: ShinobiChart) {
        crosshairPoint = pointInChart
        print("move to: \(pointInChart)")
        super.move(to: pointInChart, in: chart)
    }

    override func show(at pointInChart: CGPoint, in chart: ShinobiChart) {
        crosshairPoint = pointInChart
        print("show at: \(pointInChart)")
        super.show(at: pointInChart, in: chart)

    }

    func updateCrosshair(in chart: ShinobiChart) {
        guard let crosshairPoint = crosshairPoint else {
            return
        }
        self.show(at: crosshairPoint, in: chart)
    }

    override func hide() {
        print("hide")
       super.hide()
    }
    
}
