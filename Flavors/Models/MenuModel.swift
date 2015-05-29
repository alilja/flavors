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
    
    func getSharedFlavors(minShared: Int) -> [String: Int]{
        let names = Array(map(foods){ $0.name })
        
        // get all flavors in menu
        var flavors = Array<String>()
        println(self.foods)
        for food in self.foods{
            for flavor in food.flavors{
                if !contains(names, flavor){
                    flavors.append(flavor)
                }
            }
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
    /*
    func getNormalizedFits() -> [FoodModel: Float]{
        var output = [FoodModel: Float]()
        var max: Float = 99999.9
        var min: Float = 0.0
        for food in self.foods{
            var fit = self.getFit(food)
            if fit > max {
                max = fit
            }
            if fit < min{
                min = fit
            }
            output[food] = fit
        }
        
        for (food, fit) in output {
            output[food] = (fit - min) / (max - min)
        }
        
        return output
    }*/
}