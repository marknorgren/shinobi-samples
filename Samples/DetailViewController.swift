//
//  ChartViewController.swift
//  Samples
//
//  Created by Andrew Polkinghorn on 06/12/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import UIKit

import ShinobiCharts

class DetailViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Choose a sample!"
        
        if let splitVC = self.splitViewController {
            navigationItem.leftBarButtonItem = splitVC.displayModeButtonItem
        }
    }
}
