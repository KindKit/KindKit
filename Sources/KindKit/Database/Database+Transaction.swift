//
//  KindKit
//

import Foundation

public extension Database {
    
    enum Transaction {
        
        case deferred
        case immediate
        case exclusive
        
    }
    
}

extension Database.Transaction : IDatabaseExpressable {
    
    public var query: String {
        switch self {
        case .deferred: return "DEFERRED"
        case .immediate: return "IMMEDIATE"
        case .exclusive: return "EXCLUSIVE"
        }
    }
    
}
