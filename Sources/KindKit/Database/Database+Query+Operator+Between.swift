//
//  KindKit
//

import Foundation

public extension Database.Query.Operator {
    
    struct Between {
        
        let origin: String
        let from: IDatabaseExpressable
        let to: IDatabaseExpressable
        
    }
    
}

extension Database.Query.Operator.Between : IDatabaseCondition {
    
    public var query: String {
        let builder = StringBuilder("(")
        builder.append(self.origin)
        builder.append(" BETWEEN ")
        builder.append(self.from.query)
        builder.append(" AND ")
        builder.append(self.to.query)
        builder.append(")")
        return builder.string
    }
    
}

public extension IDatabaseTableColumn {
    
    func between(
        _ range: ClosedRange< DatabaseValueCoder.DatabaseCoded >
    ) throws -> Database.Query.Operator.Between where DatabaseValueCoder.DatabaseCoded : Comparable {
        return .init(
            origin: self.name,
            from: try DatabaseValueCoder.encode(range.lowerBound),
            to: try DatabaseValueCoder.encode(range.upperBound)
        )
    }

}
