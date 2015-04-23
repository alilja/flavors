import Foundation

struct OrderedDictionary<Tk: Hashable, Tv> {
    var keys: Array<Tk> = []
    var values: Dictionary<Tk, Tv> = [:]
    var description: String {
        var result = "{\n"
        for i in 0..<self.keys.count {
            let key = self.keys[i]
            result += "\t[\(i)]: \(key) => \(self[key])\n"
        }
        return result + "}"
    }
    
    var count: Int {
        assert(keys.count == values.count, "Keys and values array out of sync")
        return self.keys.count
    }
    
    init(){}
    
    subscript(key: Tk) -> Tv? {
        get {
            return self.values[key]
        }
        set(newValue){
            if newValue == nil {
                self.values.removeValueForKey(key)
                self.keys = self.keys.filter {$0 != key}
                return
            }
            
            let oldValue = self.values.updateValue(newValue!, forKey: key)
            if oldValue == nil {
                self.keys.append(key)
            }
        }
    }
}
println(sortedKeys)
