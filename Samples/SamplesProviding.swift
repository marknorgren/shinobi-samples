//
//  SamplesProviding.swift
//  Samples
//
//  Created by Andrew Polkinghorn on 16/12/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import UIKit

struct Sample {
    let title: String
    let type: UIViewController.Type
    let isPremium: Bool
}

protocol SamplesProviding {
    
    var title: String { get }
    
    var samples: [Sample] { get }
}
