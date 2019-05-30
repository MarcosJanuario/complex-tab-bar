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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
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
            "size": 100,
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
    
    var from: Int = 0
    
    var articlesArray = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        
        activity.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        searchBar.delegate = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        print("T I M E   S T A M P")
        let timestamp = Calendar.current.date(byAdding: .month, value: -1, to: Date())?.timeIntervalSince1970
        let currentTimestamp = Int64(NSDate().timeIntervalSince1970 * 1000)
        print("first: \(Int64(timestamp! * 1000 ))")
        print("currentTimestamp: \(currentTimestamp)")
        
        
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if error != nil {
                print(error!)
                return
            } else {
                print("NO ERROR GETTING FIREBASE TOKEN ID")
                self.setFirebaseToken(token: idToken!)
                self.prepareHeader(token: idToken!)
//                self.getData()
            }
        }
    }
    
    func setFirebaseToken(token: String) {
        fbToken = token
    }
    
    func prepareHeader(token: String) {
        headers["Authorization"] = "Bearer \(token)"
    }
    
    func setDate() {
        
        let from = Calendar.current.date(byAdding: .month, value: -1, to: Date())?.timeIntervalSince1970
        let to = Int64(NSDate().timeIntervalSince1970 * 1000)
        
        if var body = queryBody as? [String: Any] {
            if var searchParameters = body["searchParameters"] as? [String: Any] {
                
                searchParameters["dateRange"] = ["from": from ?? 0, "to": to]
                
                queryBody["searchParameters"] = searchParameters
            }
        }
    }
    
    func updateSearchTerm(searchTerms: [String]) {
        if var body = queryBody as? [String: Any] {
            if var searchParameters = body["searchParameters"] as? [String: Any] {
                
                searchParameters["searchTerms"] = searchTerms
                
                queryBody["searchParameters"] = searchParameters
            }
        }
    }
    
    func getData() {
        
        if activity.isAnimating == false {
            activity.isHidden = false
            activity.startAnimating()
        }
        
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
                self.activity.isHidden = true
                self.activity.stopAnimating()
            }
        }
        
    }
}


extension SearchController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let source = newsArray[indexPath.row].source
        let title = newsArray[indexPath.row].title
        let teaser = newsArray[indexPath.row].teaser
        let imageUrl = newsArray[indexPath.row].image
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCellIdentifier") as! NewsCell
        
        if let url = URL(string: imageUrl!) {
            
            do {
                let data = try Data(contentsOf: url)
                cell.sourceImage.image = UIImage(data: data)
//                cell.sourceImage.isHidden = false
                cell.sourceImageHC.constant = self.view.frame.size.width / 2
            } catch {
                
            }
        } else {
//            cell.sourceImage.isHidden = true
            cell.sourceImageHC.constant = 0
        }
//        self.view.layoutIfNeeded()
        
        cell.sourceLabel.text = source
        cell.titleLabel.text = title
        cell.teaserLabel.text = teaser
        
        return cell
    }
}


//MARK: SEARCH BAR METHODS
extension SearchController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Searching \(searchBar.text!)")
        
        updateSearchTerm(searchTerms: [searchBar.text!])
        
        setDate()
        
        getData()
        
//        tableView.reloadData()
    }
    
    // triggered quando o conteudo da SB é alterado
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            print("SearchBar está vazia")
            
            newsArray = []
            
            tableView.reloadData()
            // insere o nosso codigo no main thread para acontecer asyncronicamente
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // fecha o teclado do search bar e tira o focus da mesma
            }
        }
    }
}

extension UIViewController {
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
