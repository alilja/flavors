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
}
