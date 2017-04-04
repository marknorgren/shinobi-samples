//
//  ViewConstrainer.swift
//  Samples
//
//  Created by Andrew Polkinghorn on 08/12/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import UIKit

struct ViewConstrainer {
    
    static func layout(_ childView: UIView, in parentView: UIView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        childView.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 10).isActive = true
        childView.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: 10).isActive = true
        childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -10).isActive = true
        childView.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: -10).isActive = true
    }
}
