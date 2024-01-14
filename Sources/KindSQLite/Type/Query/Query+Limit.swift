//
//  KindKit
//

import Foundation

public extension Query {
    
    struct Limit {
        
        let limit: Count
        let offset: Count?
        
    }
    
}

extension Query.Limit : IExpressable {
    
    public var query: String {
        let builder = StringBuilder("LIMIT ")
        builder.append(self.limit)
        if let offset = self.offset {
            builder.append(" OFFSET ")
            builder.append(offset)
        }
        return builder.string
    }
    
}
