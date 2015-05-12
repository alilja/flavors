//
//  FlavorCell.swift
//  Flavors
//
//  Created by Andrew on 4/19/15.
//  Copyright (c) 2015 Andrew Lilja. All rights reserved.
//

import UIKit

class FlavorCell: UITableViewCell {
    
    var collectionView: UICollectionView!
    
    var owner: MainViewController!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewLeftAlignedLayout())
        let cellNib = UINib(nibName: "LabelCell", bundle: nil)
        self.collectionView.registerNib(cellNib, forCellWithReuseIdentifier: "FlavorTag")
        self.collectionView.backgroundColor = UIColor.whiteColor()
        self.collectionView.contentInset = UIEdgeInsetsMake(5, 5, 0, 10)
        self.collectionView.scrollEnabled = false
        
        self.contentView.addSubview(self.collectionView)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let frame = self.contentView.bounds
        self.collectionView.frame = CGRectMake(0, 0.5, frame.size.width, frame.size.height - 1)
    }
}
