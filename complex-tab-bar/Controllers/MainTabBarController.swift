//
//  MainTabBarController.swift
//  complex-tab-bar
//
//  Created by Marcos Januário on 19.05.19.
//  Copyright © 2019 Marcos Januário. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        guard let viewControllers = viewControllers else {
            return
        }
        
        for viewController in viewControllers {
            
            if let alertsController = viewController as? AlertsController {
                alertsController.alertsName = "Olga"
            }
            
            if let newslettersController = viewController as? NewslettersController {
                newslettersController.newslettersName = "Olga"
            }
            
            if let favoritesController = viewController as? FavoritesController {
                favoritesController.favoritesName = "Olga"
            }
        }
    }
    
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        print("Selected item")
//        print(item)
//    }
    
}
