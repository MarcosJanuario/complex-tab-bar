//
//  Settings.swift
//  complex-tab-bar
//
//  Created by Marcos Januário on 21.05.19.
//  Copyright © 2019 Marcos Januário. All rights reserved.
//

import Foundation
import RealmSwift

class Settings: Object {
    @objc dynamic var userToken: String = ""
    @objc dynamic var userEmail: String = ""
    @objc dynamic var language: String = ""
}
