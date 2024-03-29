//
//  KindKit
//

import Foundation

public extension Database {
    
    enum Value {
        
        case null
        case integer(Int)
        case real(Double)
        case text(String)
        case blob(Data)
        
    }
    
}

extension Database.Value : IDatabaseExpressable {
    
    public var query: String {
        switch self {
        case .null:
            return "NULL"
        case .integer(let value):
            return "\(value)"
        case .real(let value):
            return "\(value)"
        case .text(let value):
            return "'\(value.replacingOccurrences(of: "'", with: "''"))'"
        case .blob(let value):
            return "x'\(value.kk_hexString)'"
        }
    }
    
}
