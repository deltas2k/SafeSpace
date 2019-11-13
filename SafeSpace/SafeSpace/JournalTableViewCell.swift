//
//  JournalTableViewCell.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/12/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import UIKit

class JournalTableViewCell: UITableViewCell {

    var entry: Entry? {
        didSet {
            guard let entry = entry else {return}
            titleLabel.text = entry.titleText
            dateLabel.text = entry.timestamp.formatDate()
            moodLabel.text = String(entry.happinessBar)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var moodLabel: UILabel!
    
    
}
