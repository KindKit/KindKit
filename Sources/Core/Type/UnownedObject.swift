//
//  KindKitCore
//

import Foundation

public struct UnownedObject< Value : AnyObject > {
    
    public unowned var value: Value
    
    public init(_ value: Value) {
        self.value = value
    }
    
}
