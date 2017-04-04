//
//  AppDelegate.swift
//  Samples
//
//  Created by Andrew Polkinghorn on 06/12/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import UIKit

import ShinobiCharts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        ShinobiCharts.setLicenseKey("") // <- Enter trial key here.
        
        if let splitVC = window!.rootViewController as? UISplitViewController {
            splitVC.delegate = self
        }
        return true
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topVC = secondaryAsNavController.topViewController else { return false }
        return topVC.isKind(of: DetailViewController.self)
    }
}

