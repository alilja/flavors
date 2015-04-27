//
//  LabelCollectionViewController.swift
//  Flavors
//
//  Created by Andrew on 4/22/15.
//  Copyright (c) 2015 Andrew Lilja. All rights reserved.
//

import UIKit

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func getFlavorArray() -> Array<AnyObject> {
        if menu.foods.count == 0{
            return food_db.keys.array
        } else if menu.foods.count == 1{
            return menu.foods[0].flavors
        }
        let flavor_dict = menu.getSharedFlavors(2)
        var sortedKeys = flavor_dict.keys.array.sorted {
            return flavor_dict[$0] > flavor_dict[$1]
        }
        return sortedKeys
    }
    
    // MARK: CollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getFlavorArray().count
    }
    
    func getCellLabel(indexPath: NSIndexPath) -> String {
        let flavor = getFlavorArray()[indexPath.row] as! String
        var count = menu.getSharedFlavors(2)[flavor]
        if count == nil{
            count = 0
        }
        return "\(count!) \(flavor)"
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: LabelCell = collectionView.dequeueReusableCellWithReuseIdentifier("FlavorTag", forIndexPath: indexPath) as! LabelCell
        cell.nameLabel!.text = getCellLabel(indexPath)
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        self.sizingCell.nameLabel.text = getCellLabel(indexPath)

        var size = self.sizingCell.nameLabel.intrinsicContentSize()
        size.height *= 2
        size.width *= 1.2
        println(self.sizingCell.nameLabel.text)
        println(size)
        return size
    }
    
}