//
//  NewslettersController.swift
//  complex-tab-bar
//
//  Created by Marcos Januário on 19.05.19.
//  Copyright © 2019 Marcos Januário. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import Firebase

class NewslettersController: UIViewController {
    
    var newslettersName: String?
    var fbToken: String?
    var newsArray = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("inside newsletters: \(newslettersName!)")
    }
    
    @IBAction func openBottomOptions(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "User Options", message: "", preferredStyle: .actionSheet)
        
        //APP SETTINGS ACTION
        let appSettingsImage = UIImage(named: "appConfig")
        let actionAppSettings = UIAlertAction(title: "Settings", style: .default) { (action) in
            print("wants to see app settings!")
        }
        actionAppSettings.setValue(appSettingsImage, forKey: "image")
        alert.addAction(actionAppSettings)
        
        //LOG OUT ACTION
        let logoutImage = UIImage(named: "logout")
        let actionLogout = UIAlertAction(title: "Logout", style: .default) { (action) in
            print("wants to log out!")
        }
        actionLogout.setValue(logoutImage, forKey: "image")
        alert.addAction(actionLogout)
        
        // CANCEL ACTION
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
