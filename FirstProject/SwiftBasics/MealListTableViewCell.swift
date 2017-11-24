//
//  MealListTableViewCell.swift
//  SwiftBasics
//
//  Created by aashish chadha on 20/10/17.
//  Copyright © 2017 vishalb. All rights reserved.
//

import UIKit

class MealListTableViewCell: UITableViewCell {

    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var movieYear: UILabel!
    //  @IBOutlet weak var mealRating: CustomStarView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
