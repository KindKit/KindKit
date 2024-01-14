//
//  KindKit
//

import Foundation

public extension Query {
    
    struct OrderBy {
        
        let column: String
        let mode: Mode
        
    }
    
}

extension Query.OrderBy : IExpressable {
    
    public var query: String {
        return "\(self.column) \(self.mode.query)"
    }
    
}
