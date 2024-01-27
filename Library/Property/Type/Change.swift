//
//  KindKit
//

import KindCore

public struct Change< Value > {
    
    public let old: Value
    public let new: Value
    
    public init(old: Value, new: Value) {
        self.old = old
        self.new = new
    }
    
}
