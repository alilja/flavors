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

var foods = [FoodModel]()

let path = NSBundle.mainBundle().pathForResource("foods", ofType: "plist")
var food_data = NSDictionary(contentsOfFile: path!)

for (food, data) in food_data!{
    var techniques = Array<String>()
    var flavors = Array<String>()
    var seasons = Array<String>()
    for (key, value) in data as! NSDictionary{
        if key as! String == "Flavors"{
            flavors = value as! Array<String>
        }
        if key as! String == "Technique"{
            techniques = value as! Array<String>
        }
        if key as! String == "Seasons"{
            seasons = value as! Array<String>
        }
    }
    foods.append(FoodModel(name: food as! String, flavors: flavors, technique: techniques, seasons: seasons))
}
