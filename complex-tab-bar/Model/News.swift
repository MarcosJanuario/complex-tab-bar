//
//  News.swift
//  complex-tab-bar
//
//  Created by Marcos Januário on 21.05.19.
//  Copyright © 2019 Marcos Januário. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Firebase

class News {
    var title: String?
    var source: String?
    var url: String?
    var text: String?
    var teaser: String?
    var image: String?
    var time: Int64?
    
    init(doc: JSON) {
        self.title = doc["contentTitle"]["full"].string ?? nil
        self.source = doc["sourceMediaName"].string ?? nil
        self.url = doc["contentUrl"].string ?? nil
        self.text = doc["contentText"]["full"].string ?? nil
        self.teaser = doc["contentTeaser"]["full"].string ?? nil
        self.image = getArticleImage(doc: doc)
        self.time = doc["contentTimestamp"].int64 ?? nil
    }
    
    func getArticleImage(doc: JSON) -> String {
        var image: String = ""
        if let docImage = doc["contentThumbUrl"].string {
            image = docImage
        }
        if let docImage = doc["contentThumbSmallUrl"].string {
            image = docImage
        }
        return image
    }
}
