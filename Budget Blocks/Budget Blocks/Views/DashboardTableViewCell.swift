//
//  DashboardTableViewCell.swift
//  Budget Blocks
//
//  Created by Isaac Lyons on 2/5/20.
//  Copyright © 2020 Isaac Lyons. All rights reserved.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let textSize = titleLabel.font.pointSize
        titleLabel.font = UIFont(name: "Exo-Regular", size: textSize)
        
        backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
    }

}
