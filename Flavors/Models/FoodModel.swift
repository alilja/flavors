//
//  FoodModel.swift
//  Flavors
//
//  Created by Andrew on 4/18/15.
//  Copyright (c) 2015 Andrew Lilja. All rights reserved.
//

import Foundation

class FoodModel: NSObject {
    let name: String
    let flavors: Array<String>
    let technique: Array<String>
    let seasons: Array<String>
    var menu: MenuModel?
    
    init(name: String, flavors: Array<String>, technique: Array<String>, seasons: Array<String>){
        self.name = name.lowercaseString
        self.flavors = flavors
        self.technique = technique
        self.seasons = seasons
    }
    
    func getSimilarity(target: FoodModel) -> Float{
        let my_set = Set(self.flavors + [self.name])
        let target_set = Set(target.flavors)
        
        var denom = 1
        if my_set.count > target_set.count{
            denom = target_set.count
        } else if my_set.count < target_set.count{
            denom = my_set.count
        }
        
        return Float(my_set.intersect(target_set).count) / Float(denom)
    }
}