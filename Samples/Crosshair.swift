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
    override init(chart parentChart: ShinobiChart) {
        super.init(chart: parentChart)

        self.style = crosshairStyle()
    }

    func crosshairStyle() -> SChartCrosshairStyle {
        let crosshairStyle = SChartCrosshairStyle()

        crosshairStyle.lineColor = UIColor.black
        crosshairStyle.lineWidth = 2.0

        return crosshairStyle
    }
    
    
}
