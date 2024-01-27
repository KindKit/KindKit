//
//  KindKit
//

public extension Dictionary {
    
    @inlinable
    func kk_appending(key: Key, value: Value) -> Self {
        if self.isEmpty == true {
            return [ key : value ]
        }
        var result = self
        result[key] = value
        return result
    }
    
    @inlinable
    func kk_countValues(where: (Value) -> Bool) -> Int {
        var result = 0
        for element in self {
            if `where`(element.value) == true {
                result += 1
            }
        }
        return result
    }
    
    @inlinable
    func kk_trueMap< NewKey : Hashable, NewValue >(_ transform: ((key: Key, value: Value)) -> (key: NewKey, value: NewValue)) -> Dictionary< NewKey, NewValue > {
        var result = Dictionary< NewKey, NewValue >()
        for item in self {
            let new = transform(item)
            result[new.key] = new.value
        }
        return result
    }

}
