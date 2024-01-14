//
//  KindKit
//

import Foundation

public extension Query.OrderBy {
    
    enum Mode {
        
        case asc
        case desc
        
    }
    
}

extension Query.OrderBy.Mode : IExpressable {
    
    public var query: String {
        switch self {
        case .asc: return "ASC"
        case .desc: return "DESC"
        }
    }
    
}
