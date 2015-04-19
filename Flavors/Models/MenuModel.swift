//
//  MenuModel.swift
//  Flavors
//
//  Created by Andrew on 4/18/15.
//  Copyright (c) 2015 Andrew Lilja. All rights reserved.
//

import Foundation

class MenuModel{
    private var _foods: Array<FoodModel>
    var foods: Array<FoodModel> {
        get {
            return self._foods
        }
        set(newFoods) {
            self._foods = newFoods
            for food in self._foods{
                food.menu = self
            }
        }
    }
    
    init(foods: Array<FoodModel>){
        self._foods = Array<FoodModel>()
        self.foods = foods
    }
    
    func add(newFoods: Array<FoodModel>){
        for food in newFoods{
            self.foods.append(food)
        }
    }
    
    func add(newFood: FoodModel){
        self.add([newFood])
    }
    
    func names() -> Array<String>{
        var output = [String]()
        for food in self.foods{
            output.append(food.name)
        }
        return output
    }
    
    func getSharedFlavors(minShared: Int) -> [String: Int]{
        // get all flavors in menu
        var flavors = Array<String>()
        for food in self.foods{
            for flavor in food.flavors{
                flavors.append(flavor)
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
