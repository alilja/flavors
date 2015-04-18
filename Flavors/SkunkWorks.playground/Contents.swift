//: Playground - noun: a place where people can play

import UIKit

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
}

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
    let flavors: Set<String>
    let technique: String
    let seasons: Set<String>
    var menu: MenuModel?
    
    init(name: String, flavors: Set<String>, technique: String, seasons: Set<String>){
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
        var flavors = [String]()
        for food in self.menu!.foods{
            flavors.extend(food.flavors)
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



let test_a = FoodModel(name: "A", flavors: ["a","b"], technique: "alpha", seasons: ["beta"])
let test_b = FoodModel(name: "B", flavors: ["b","c","d"], technique: "alpha", seasons: ["beta"])


var menu = MenuModel(foods: [test_a, test_b])

let fit = test_a.getFit()
let shared = test_a.getSharedFlavors(1)