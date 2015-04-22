//
//  LabelCollectionViewController.swift
//  Flavors
//
//  Created by Andrew on 4/22/15.
//  Copyright (c) 2015 Andrew Lilja. All rights reserved.
//

import UIKit

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if menu.foods.count == 0{
            return food_db.count
        } else if menu.foods.count == 1{
            return menu.foods[0].flavors.count
        }
        return menu.getSharedFlavors(2).keys.array.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: LabelCell = collectionView.dequeueReusableCellWithReuseIdentifier("FlavorTag", forIndexPath: indexPath) as! LabelCell
        var labelText:String
        
        if menu.foods.count == 0{
            labelText = self.food_db.keys.array[indexPath.row]
        } else if menu.foods.count == 1 {
            labelText = menu.foods[0].flavors[indexPath.row]
        } else {
             labelText = menu.getSharedFlavors(2).keys.array[indexPath.row]
        }
        cell.countLabel!.text = labelText
        return cell
    }
}