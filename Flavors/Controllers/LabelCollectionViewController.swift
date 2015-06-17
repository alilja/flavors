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
        if menu.foods.count == 1{
            return menu.foods[0].flavors
        }
        var sortedKeys = self.sharedFlavors.keys.array.sorted {
            return self.sharedFlavors[$0] > self.sharedFlavors[$1]
        }
        return sortedKeys
    }
    
    func getCellLabel(indexPath: NSIndexPath) -> String {
        if menu.foods.count == 1 {
            let flavor = menu.foods[0].flavors[indexPath.row]
            return "\(flavor)"
        }
        let flavor = getFlavorArray()[indexPath.row] as! String
        var count = self.sharedFlavors[flavor]
        if count == nil{
            return ""
        }
        return "\(count!) \(flavor)"
    }
    
    func getCellBackgroundColor(indexPath: NSIndexPath) -> CGFloat {
        if menu.foods.count == 1 {
            return 1.0
        }
        let maxCount = self.sharedFlavors[getFlavorArray()[0] as! String]
        let count = self.sharedFlavors[getFlavorArray()[indexPath.row] as! String]
        return CGFloat(count!)/CGFloat(maxCount!)
    }
    
    // MARK: CollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if menu.foods.count == 0{
            return 0
        }
        return getFlavorArray().count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: LabelCell = collectionView.dequeueReusableCellWithReuseIdentifier("FlavorTag", forIndexPath: indexPath) as! LabelCell
        
        cell.nameLabel!.text = getCellLabel(indexPath)
        cell.layer.cornerRadius = self.sizingCell.nameLabel.intrinsicContentSize().height
        cell.layer.masksToBounds = true
        let white = getCellBackgroundColor(indexPath)
        cell.backgroundColor = UIColor(white: white, alpha: 1.0)
        if white <= 0.5 {
            cell.nameLabel!.textColor = UIColor.whiteColor()
        } else {
            cell.nameLabel!.textColor = UIColor.blackColor()
        }
        
        let foodKey = getFlavorArray()[indexPath.row] as! String
        let food = food_db[foodKey]
        cell.associatedFoodModel = food
        
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "cellTap:"))
        return cell
        
    }
    
    func cellTap(recognizer: UITapGestureRecognizer){
        let foodToAdd = (recognizer.view as! LabelCell).associatedFoodModel
        if !contains(menu.foods, foodToAdd){
            menu.add(foodToAdd)
            self.menuChanged()
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        self.sizingCell.nameLabel.text = getCellLabel(indexPath)

        var size = self.sizingCell.nameLabel.intrinsicContentSize()
        size.height *= 2
        size.width = size.width * 1.2 + 7
        return size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        let cell: LabelCell = collectionView.cellForItemAtIndexPath(indexPath) as! LabelCell
        menu.add(cell.associatedFoodModel)
        self.menuChanged()
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
}