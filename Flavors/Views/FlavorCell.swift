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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        self.collectionView.registerNib(UINib(nibName: "LabelCell", bundle: nil), forCellWithReuseIdentifier: "FlavorTag")
        self.collectionView.backgroundColor = UIColor.lightGrayColor()
        
        self.contentView.addSubview(self.collectionView)
        self.layoutMargins = UIEdgeInsetsMake(10, 0, 10, 0)
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
