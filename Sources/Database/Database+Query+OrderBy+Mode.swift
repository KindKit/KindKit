//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database.Query.OrderBy {
    
    enum Mode {
        
        case asc
        case desc
        
    }
    
}

extension Database.Query.OrderBy.Mode : IDatabaseExpressable {
    
    public var query: String {
        switch self {
        case .asc: return "ASC"
        case .desc: return "DESC"
        }
    }
    
}
