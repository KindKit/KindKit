//
//  KindKit
//

import Foundation

public struct WeakObject< Value : AnyObject > {
    
    public weak var value: Value?
    
    public init(_ value: Value? = nil) {
        self.value = value
    }
    
}
