//
//  FoodCell.swift
//  Flavors
//
//  Created by Andrew on 4/19/15.
//  Copyright (c) 2015 Andrew Lilja. All rights reserved.
//

import UIKit

class FoodCell: UITableViewCell {

    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var fitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
