//
//  MealTableViewCell.swift
//  FoodTracker
//
//  Created by Jafar Yormahmadzoda on 24/02/2017.
//  Copyright © 2017 Jafar Yormahmadzoda. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

/*
 XIB files are an older way of designing the views managed by a view controller. They predate storyboards and basically represent a single scene from a storyboard. You won’t need an XIB file for this view controller, because you have already defined its content in the app’s storyboard
 */
