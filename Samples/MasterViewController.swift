//
//  MasterViewController.swift
//  Samples
//
//  Created by Andrew Polkinghorn on 06/12/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import UIKit

import ShinobiCharts

class MasterViewController: UITableViewController {
    
    private let chartTypeSamplesProvider = ChartTypeSamplesProvider()
    private let chartFeatureSamplesProvider = ChartFeatureSamplesProvider()
    
    let disablePremiumSamples = ShinobiCharts.getInfo().lowercased().contains("standard")
    
    func samplesProvider(forSection section: Int) -> SamplesProviding {
        if section == 0 {
            return chartTypeSamplesProvider
        }
         return chartFeatureSamplesProvider
    }
    
    func chartSamples(forSection section: Int) -> [Sample] {
        return samplesProvider(forSection: section).samples
    }
}

// MARK: - Table View Data Source
extension MasterViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chartSamples(forSection: section).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SampleCell", for: indexPath) as! SampleCell
        
        let samples = chartSamples(forSection: indexPath.section)
        let sample = samples[indexPath.row]
        if(sample.isPremium && disablePremiumSamples) {
            cell.contentView.alpha = 0.3
        } else {
            cell.contentView.alpha = 1
        }
        
        cell.label.text = sample.title
        cell.premiumImageView.isHidden = !sample.isPremium
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return samplesProvider(forSection: section).title
    }
}

// MARK: - Table View Delegate
extension MasterViewController {
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let samples = chartSamples(forSection: indexPath.section)
        let sample = samples[indexPath.row]
        return !disablePremiumSamples || !sample.isPremium
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let splitVC = splitViewController,
            let navVC = splitVC.viewControllers.last as? UINavigationController {
            let samples = chartSamples(forSection: indexPath.section)
            let sampleVC = viewController(for: samples[indexPath.row], applying: splitVC.displayModeButtonItem)
            
            if navVC.topViewController is MasterViewController {
                navVC.pushViewController(sampleVC, animated: true)
            } else {
                navVC.viewControllers = []
                navVC.pushViewController(sampleVC, animated: false)
            }
            
            splitVC.showDetailViewController(navVC, sender: nil)
        }
    }
    
    private func viewController(for sample: Sample, applying leftBarButtonItem: UIBarButtonItem) -> UIViewController {
        let viewController = sample.type.init()
        viewController.navigationItem.leftItemsSupplementBackButton = true
        viewController.navigationItem.leftBarButtonItem = leftBarButtonItem
        viewController.navigationItem.title = sample.title
        viewController.view.backgroundColor = .white
        return viewController
    }
}

