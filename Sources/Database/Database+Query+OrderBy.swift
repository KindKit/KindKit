//
//  KindKit
//

import Foundation

public extension Database.Query {
    
    struct OrderBy {
        
        let column: String
        let mode: Mode
        
    }
    
}

extension Database.Query.OrderBy : IDatabaseExpressable {
    
    public var query: String {
        return "\(self.column) \(self.mode.query)"
    }
    
}
