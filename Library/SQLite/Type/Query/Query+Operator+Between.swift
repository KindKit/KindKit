//
//  KindKit
//

import KindString

public extension Query.Operator {
    
    struct Between {
        
        let origin: String
        let from: IExpressable
        let to: IExpressable
        
    }
    
}

extension Query.Operator.Between : ICondition {
    
    public var query: String {
        return .kk_build({
            LettersComponent("(")
            LettersComponent(self.origin)
            LettersComponent(" BETWEEN ")
            LettersComponent(self.from.query)
            LettersComponent(" AND ")
            LettersComponent(self.to.query)
            LettersComponent(")")
        })
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
