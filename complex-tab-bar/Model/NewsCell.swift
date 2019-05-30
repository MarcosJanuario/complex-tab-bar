//
//  NewsCell.swift
//  complex-tab-bar
//
//  Created by Marcos Januário on 24.05.19.
//  Copyright © 2019 Marcos Januário. All rights reserved.
//
import Foundation
import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var sourceImage: UIImageView!
    @IBOutlet weak var sourceImageHC: NSLayoutConstraint!
    
    @IBOutlet weak var sourceLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var teaserLabel: UILabel!
}
