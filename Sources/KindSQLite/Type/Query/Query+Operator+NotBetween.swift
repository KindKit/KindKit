//
//  KindKit
//

import Foundation

public extension Query.Operator {
    
    struct NotBetween {
        
        let origin: String
        let from: IExpressable
        let to: IExpressable
        
    }
    
}

extension Query.Operator.NotBetween : ICondition {
    
    public var query: String {
        let builder = StringBuilder("(")
        builder.append(self.origin)
        builder.append(" NOT BETWEEN ")
        builder.append(self.from.query)
        builder.append(" AND ")
        builder.append(self.to.query)
        builder.append(")")
        return builder.string
    }
    
}

public extension ITableColumn {
    
    func notBetween(
        _ range: ClosedRange< SQLiteValueCoder.SQLiteCoded >
    ) throws -> Query.Operator.NotBetween where SQLiteValueCoder.SQLiteCoded : Comparable {
        return .init(
            origin: self.name,
            from: try SQLiteValueCoder.encode(range.lowerBound),
            to: try SQLiteValueCoder.encode(range.upperBound)
        )
    }

}
