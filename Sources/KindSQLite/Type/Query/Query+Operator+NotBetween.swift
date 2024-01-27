//
//  KindKit
//

import KindString

public extension Query.Operator {
    
    struct NotBetween {
        
        let origin: String
        let from: IExpressable
        let to: IExpressable
        
    }
    
}

extension Query.Operator.NotBetween : ICondition {
    
    public var query: String {
        return .kk_build({
            LettersComponent("(")
            LettersComponent(self.origin)
            LettersComponent(" NOT BETWEEN ")
            LettersComponent(self.from.query)
            LettersComponent(" AND ")
            LettersComponent(self.to.query)
            LettersComponent(")")
        })
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
