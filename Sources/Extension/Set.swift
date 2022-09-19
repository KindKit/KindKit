//
//  KindKit
//

import Foundation

public extension Set {
    
    init(range: Range< Element >) where Element : Strideable, Element.Stride : SignedInteger {
        self.init()
        for value in range {
            self.insert(value)
        }
    }
    
}
