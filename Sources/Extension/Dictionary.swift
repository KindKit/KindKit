//
//  KindKit
//

import Foundation

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
    func kk_countValues(where: (_ element: Value) -> Bool) -> Int {
        var result = 0
        for element in self {
            if `where`(element.value) == true {
                result += 1
            }
        }
        return result
    }

}
