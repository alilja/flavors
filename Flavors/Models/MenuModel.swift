//
//  MenuModel.swift
//  Flavors
//
//  Created by Andrew on 4/18/15.
//  Copyright (c) 2015 Andrew Lilja. All rights reserved.
//

import Foundation

class MenuModel{
    var foodNames = [String]()
    
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
            self.foodNames = Array(map(self._foods){ $0.name })
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
    
    
    func getSharedFlavors(minShared: Int) -> [String: Int]{
        // get all flavors in menu
        var flavors = Array<String>()
        for food in self.foods{
            for flavor in food.flavors{
                if !contains(self.foodNames, flavor){
                    flavors.append(flavor)
                }
            }
        }
        
        if flavors.count == 0{
            return ["": 0]
        }
        
        // count them
        var counted_flavors = [String: Int]()
        for flavor in flavors{
            counted_flavors[flavor] = (counted_flavors[flavor] ?? 0) + 1
        }
        
        // return them if there are > minShared
        var shared = [String: Int]()
        for (flavor, count) in counted_flavors{
            if count >= minShared{
                shared[flavor] = count
            }
        }
        
        return shared
    }
    
    func getSharedFoodFlavors(food: FoodModel, minShared: Int) -> [String]{
        let shared = Set(getSharedFlavors(minShared).keys)
        return Array(shared.intersect(Set(food.flavors)))
    }
    
    
    func getFits() -> [FoodModel: Float]{
        if self.foods.count == 1{
            return [self.foods[0]: Float(1.0)]
        }
        
        var output = [FoodModel: Float]()
        for this_food in self.foods{
            var avg_fit: Float = 0.0
            for target_food in self.foods{
                if this_food != target_food{
                    avg_fit += this_food.getSimilarity(target_food)
                }
            }
            output[this_food] = avg_fit / Float(self.foods.count - 1)
        }
        return output
    }
}