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
}
