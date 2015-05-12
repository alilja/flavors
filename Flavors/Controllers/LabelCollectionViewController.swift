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
    
    func getCellLabel(indexPath: NSIndexPath) -> String {
        if menu.foods.count == 0 {
            let food = food_db.keys.array[indexPath.row]
            return "\(food)"
        } else if menu.foods.count == 1 {
            let flavor = menu.foods[0].flavors[indexPath.row]
            return "\(flavor)"
        }
        let flavor = getFlavorArray()[indexPath.row] as! String
        var count = menu.getSharedFlavors(1)[flavor]
        if count == nil{
            count = 0
        }
        return "\(count!) \(flavor)"
    }
    
    // MARK: CollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getFlavorArray().count
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
        size.width = size.width * 1.2 + 5
        return size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
}