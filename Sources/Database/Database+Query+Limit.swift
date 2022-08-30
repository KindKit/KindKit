//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database.Query {
    
    struct Limit {
        
        let limit: Database.Count
        let offset: Database.Count?
        
    }
    
}

extension Database.Query.Limit : IDatabaseExpressable {
    
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
