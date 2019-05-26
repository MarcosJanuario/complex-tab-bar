//
//  AlertsController.swift
//  complex-tab-bar
//
//  Created by Marcos Januário on 19.05.19.
//  Copyright © 2019 Marcos Januário. All rights reserved.
//

import Foundation
import UIKit

class AlertsController: UIViewController {
    
    var alertsName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("inside alerts: \(alertsName!)")
    }
}
