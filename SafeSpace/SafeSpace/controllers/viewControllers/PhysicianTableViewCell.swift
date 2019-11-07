//
//  PhysicianTableViewCell.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/6/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import UIKit

class PhysicianTableViewCell: UITableViewCell {

    var ratingStars: UIImage?
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    
    var physicians: Businesses? {
        didSet {
            guard let physician = physicians else {return}
            nameLabel.text = physician.name
            //distanceLabel.text = "\(physician.distance)"
            ratingCountLabel.text = "\(physician.review_count)"
            
            if physician.rating == 0 {
                ratingImageView.image = UIImage(named: "small_0")
            } else if physician.rating == 1.0 {
                ratingImageView.image = UIImage(named: "small_1")
            } else if physician.rating == 1.5 {
                ratingImageView.image = UIImage(named: "small_1_half")
            } else if physician.rating == 2.0 {
                ratingImageView.image = UIImage(named: "small_2")
            } else if physician.rating == 2.5 {
                ratingImageView.image = UIImage(named: "small_2_half")
            } else if physician.rating == 3.0 {
                ratingImageView.image = UIImage(named: "small_3")
            } else if physician.rating == 3.5 {
                ratingImageView.image = UIImage(named: "small_3_half")
            } else if physician.rating == 4.0 {
                ratingImageView.image = UIImage(named: "small_4")
            } else if physician.rating == 4.5 {
                ratingImageView.image = UIImage(named: "small_4_half")
            } else if physician.rating == 5.0 {
                ratingImageView.image = UIImage(named: "small_5")
            }
            photoImageView.image = nil
            
           PhysicianController.getImage(image: physician) { (image) in
//                if let image = image {
                   DispatchQueue.main.async {
                       self.photoImageView.image = image
//                    }
               }
            }
        }
    }
}
