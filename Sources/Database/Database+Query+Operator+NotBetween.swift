//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database.Query.Operator {
    
    struct NotBetween {
        
        let origin: String
        let from: String
        let to: String
        
    }
    
}

extension Database.Query.Operator.NotBetween : IDatabaseCondition {
    
    public var query: String {
        let builder = StringBuilder("(")
        builder.append(self.origin)
        builder.append(" NOT BETWEEN ")
        builder.append(self.from)
        builder.append(" AND ")
        builder.append(self.to)
        builder.append(")")
        return builder.string
    }
    
}

public extension Database.Table.Column {
    
    func notBetween(_ range: ClosedRange< Value >) -> Database.Query.Operator.NotBetween where Value : Comparable {
        return .init(origin: self.name, from: range.lowerBound.query, to: range.upperBound.query)
    }

}
