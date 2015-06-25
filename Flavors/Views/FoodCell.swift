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
    @IBOutlet weak var fitIndicator: UIView!
    @IBOutlet weak var matchingFlavorsLabel: UILabel!
    
    let fitColors = ["ED2A23", "DA572C", "C68F34", "CCCC27", "96AF51", "7BB75E", "4EB96E"]
    
    // from https://gist.github.com/arshad/de147c42d7b3063ef7bc
    func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(advance(cString.startIndex, 1))
        }
        
        if (count(cString) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func updateFit(fit: Float){
        var verified_fit = fit;
        if fit.isNaN{
            verified_fit = 0.0
        }
        let index = Int(floor(verified_fit * 6))
        self.fitIndicator.backgroundColor = colorWithHexString(self.fitColors[index])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
