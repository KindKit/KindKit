//
//  KindKit
//

import Foundation

public extension Set {
    
    @inlinable
    static func kk_make(range: Range< Element >) -> Self where Element : Strideable, Element.Stride : SignedInteger {
        var set = Set()
        for value in range {
            set.insert(value)
        }
        return set
    }
    
}
