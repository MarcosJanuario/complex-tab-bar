//
//  SearchController.swift
//  complex-tab-bar
//
//  Created by Marcos Januário on 21.05.19.
//  Copyright © 2019 Marcos Januário. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import Firebase

class SearchController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var fbToken: String?
    
    var newsArray = [News]()
    
    var queryBody: Parameters = [
        "clientToken": "",
        "searchParameters": [
            "aggs": [
                [
                    "aggName": "gross_reach",
                    "aggType": "date_histogram"
                ],
                [
                    "aggName": "gross_reach",
                    "aggType": "sum"
                ]
                
            ],
            "branch": "military",
            "countries": [],
            "dateRange": [
                "from": 1550506493260,
                "to": 1551111293260
            ],
            "docFields": [
                "sourceType",
                "contentTitle.full",
                "contentTeaser.full",
                "contentText.full",
                "contentMediaUrl",
                "contentSentiment",
                "contentTimestamp",
                "geoCountryCode",
                "metricsFollowers",
                "sourceMediaName",
                "contentThumbSmallUrl",
                "contentThumbUrl",
                "contentUrl"
            ],
            "searchTerms": ["apple"],
            "from": 0,
            "size": 40,
            "sort": [
                "order": "desc",
                "sortBy": "contentTimestamp"
            ],
            "sourceTypes": ["news"]
        ]
    ]
    
    var headers: HTTPHeaders = [
        "Authorization": "",
        "Accept": "application/json",
        "firebase-project-Id": "prime-news-app-dev"
    ]
    
    var searchTerm: [String] = ["airbus"]
    
    var from: Int = 0
    
    var articlesArray = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        tableView.estimatedRowHeight = 100
//        tableView.rowHeight = UITableView.automaticDimension
        
        
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if error != nil {
                print(error!)
//                do {
//                    try Auth.auth().signOut()
//                } catch {
//
//                }
                return
            } else {
                print("NO ERROR GETTING FIREBASE TOKEN ID")
                self.setFirebaseToken(token: idToken!)
                self.prepareHeader(token: idToken!)
                self.getData()
            }
        }
    }
    
    func setFirebaseToken(token: String) {
        fbToken = token
    }
    
    func prepareHeader(token: String) {
        headers["Authorization"] = "Bearer \(token)"
    }
    
    func getData() {
        queryBody["clientToken"] = fbToken
        
        Alamofire.request("https://walls-proxy.prime-intra.net/api/news", method: .post, parameters: queryBody, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if response.result.isSuccess {
                let jsonResult: JSON = JSON(response.result.value!)
                
                let hits = jsonResult["esResponse"]["hits"]["hits"]
                print(hits[0]["_source"]["contentTitle"]["full"])
                print(self.view.frame.size.width)
                
                for hit in hits.arrayValue {
                    let source = hit["_source"]
                    let article = News(doc: source)
                    self.newsArray.append(article)
                }
                self.tableView.reloadData()
            }
        }
        
    }
}


extension SearchController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = newsArray[indexPath.row].title
        let teaser = newsArray[indexPath.row].teaser
        let imageUrl = newsArray[indexPath.row].image
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCellIdentifier") as! NewsCell
        
        if let url = URL(string: imageUrl!) {
            
            do {
                let data = try Data(contentsOf: url)
                cell.sourceImage.image = UIImage(data: data)
                cell.sourceImageHC.constant = self.view.frame.size.width / 2
            } catch {
                
            }
        } else {
            cell.sourceImageHC.constant = 0
        }
        
        
        cell.titleLabel.text = title
        cell.teaserLabel.text = teaser
        
        return cell
    }
}
