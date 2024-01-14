//
//  KindKit
//

import Foundation

public extension Query.Operator {
    
    struct Between {
        
        let origin: String
        let from: IExpressable
        let to: IExpressable
        
    }
    
}

extension Query.Operator.Between : ICondition {
    
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

public extension ITableColumn {
    
    func between(
        _ range: ClosedRange< SQLiteValueCoder.SQLiteCoded >
    ) throws -> Query.Operator.Between where SQLiteValueCoder.SQLiteCoded : Comparable {
        return .init(
            origin: self.name,
            from: try SQLiteValueCoder.encode(range.lowerBound),
            to: try SQLiteValueCoder.encode(range.upperBound)
        )
    }

}
