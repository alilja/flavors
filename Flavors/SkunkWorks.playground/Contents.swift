//: Playground - noun: a place where people can play

import UIKit

class FoodModel {
    let name: String
    let flavors: Set<String>
    let technique: String
    let seasons: Set<String>
    
    init(name: String, flavors: Set<String>, technique: String, seasons: Set<String>){
        self.name = name.lowercaseString
        self.flavors = flavors
        self.technique = technique
        self.seasons = seasons
    }
    
    func getFit(menu: MenuModel) -> Int{
        var shared_flavors = menu.getSharedFlavors(1).keys.array
        var fit: Int = 0
        for flavor in shared_flavors{
            if contains(self.flavors, flavor){
                fit += 1
            }
        }
        return fit
    }
}

class MenuModel{
    let foods: Array<FoodModel>
    
    init(foods: Array<FoodModel>){
        self.foods = foods
    }
    
    func getSharedFlavors(minShared: Int) -> [String: Int]{
        // get all flavors in menu
        var flavors = [String]()
        for food in self.foods{
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

let test_a = FoodModel(name: "A", flavors: ["a","b","c"], technique: "alpha", seasons: ["beta"])
let test_b = FoodModel(name: "B", flavors: ["b","c","d"], technique: "alpha", seasons: ["beta"])


var menu = MenuModel(foods: [test_a, test_b])
let shared_count = menu.getSharedFlavors(2)