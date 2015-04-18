//
//  FoodModel.swift
//  Flavors
//
//  Created by Andrew on 4/18/15.
//  Copyright (c) 2015 Andrew Lilja. All rights reserved.
//

import Foundation

class FoodModel {
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
    
    func getFit() -> Float{
        var shared_flavors = self.getSharedFlavors(1).keys.array
        var fit: Int = 0
        for flavor in shared_flavors{
            if contains(self.flavors, flavor){
                fit += 1
            }
        }
        return Float(fit) / Float(shared_flavors.count)
    }
    
    func getSharedFlavors(minShared: Int) -> [String: Int]{
        // get all flavors in menu
        var flavors = Set<String>()
        for food in self.menu!.foods{
            for flavor in food.flavors{
                flavors.insert(flavor)
            }
        }
        
        // count them
        var counted_flavors = [String: Int]()
        for flavor in flavors{
            counted_flavors[flavor] = (counted_flavors[flavor] ?? 0) + 1
        }
        
        // return them if there are > minShared
        var output = [String: Int]()
        for (flavor, count) in counted_flavors{
            if count >= minShared{
                output[flavor] = count
            }
        }
        return output
    }
}