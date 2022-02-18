//
//  KindKitCore
//

import Foundation

public extension Dictionary {
    
    @inlinable
    func countValues(where: (_ element: Value) -> Bool) -> Int {
        var result = 0
        for element in self {
            if `where`(element.value) == true {
                result += 1
            }
        }
        return result
    }

}
